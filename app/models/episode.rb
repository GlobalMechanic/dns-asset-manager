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

  def download_scenes_assets
    assets = []
    self.scenes.each do |scene|
      if scene.assets.length > 0
        scene.assets.each do |asset|
          assets << asset
        end
      end
    end
    t = Tempfile.new("temp-episode-zip-#{Time.now.strftime("%Y-%m-%d-%H-%M")}.zip")
    Zip::ZipOutputStream.open(t.path) do |z|
      assets.each do |asset|
        puts asset.filename
        z.put_next_entry(asset.filename)
        Kernel::open('https://asset-manager.s3.amazonaws.com/uploads/asset/preview_swf/' + asset.id.to_s + '/' + File.basename(asset.preview_swf_url).to_s) {|file|
          z.print file.read
        }
      end
    end
    # send_file t.path, :type => 'application/zip', :disposition => 'attachment', :filename => "1#{self.number.pad}_assets_#{Time.now.strftime("%Y-%m-%d-%H-%M")}.zip"
    t.close
    # puts t.path
    # Put up to S3
    puts "Sending up to S3"
    connection = Fog::Storage.new(
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['S3_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET'],
    )
    connection.put_object(
      ENV['S3_BUCKET_NAME'],
      File.join("episode-scenes", "scenes-#{Time.now.strftime("%Y-%m-%d-%H-%M")}.zip"),
      File.open(t.path)
    )
    puts "Sent up to S3"

    # Send email
    # t.unlink # Clean up
  end
  handle_asynchronously :download_scenes_assets

end
