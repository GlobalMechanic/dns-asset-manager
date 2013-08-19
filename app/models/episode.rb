class Episode < ActiveRecord::Base
  #has_many :assets, :through => :reel_assets
  attr_accessible :number, :title, :season, :world
  has_many :scenes
  has_many :assets
  validates :season, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 }

  WORLD = [
    ['Desert', 'dsrt'],
    ['Water', 'wtr'],
    ['Mountain', 'mtn'],
    ['Jungle', 'jngl'],
  ]

  def download_scenes_assets(email)
    assets = []
    filenames = []
    alpha = ['a', 'b', 'c', 'd', 'e', 'f']
    self.scenes.each do |scene|
      if scene.assets.length > 0
        scene.assets.each do |asset|
          filename = asset.filename
          duplicates = filenames.select { |a| a[/^#{filename}/] }
          if duplicates.length > 0
            leftover, name, extension = filename.split(/^(.*)\.(.*)$/)
            filenames << name + alpha[duplicates.length] + '.' + extension
          else
            filenames << asset.filename
          end
          assets << asset
        end
      end
    end

    connection = Fog::Storage.new(
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['S3_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET'],
    )

    t = Tempfile.new("temp-episode-zip-#{Time.now.strftime("%Y-%m-%d-%H-%M")}.zip")
    Zip::ZipOutputStream.open(t.path) do |z|
      assets.each_with_index do |asset, index|
        puts "Adding file: #{filenames[index]}"
        z.put_next_entry(filenames[index])
        # ENV['S3_BUCKET_NAME'],
        connection.get_object('asset-manager', 'uploads/asset/preview_swf/' + asset.id.to_s + '/' + File.basename(asset.preview_swf_url).to_s) do |data|
          z.print data
        end
      end
    end
    t.close

    puts "Sending up to S3: #{t.path}"
    connection = Fog::Storage.new(
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['S3_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET'],
    )
    upload_name = File.join("episode-scenes", "scenes-#{Time.now.strftime("%Y-%m-%d-%H-%M")}.zip")
    connection.put_object(
      ENV['S3_BUCKET_NAME'],
      upload_name,
      File.open(t.path),
      { 'x-amz-acl' => 'public-read' }
    )
    puts "Sent up to S3"

    puts "Send an email: #{email}"
    DownloadMailer.download_ready(email, self, upload_name).deliver
    puts "Sent an email"

    t.unlink # Delete temp file.
  end
  handle_asynchronously :download_scenes_assets

end
