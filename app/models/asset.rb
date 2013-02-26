class Asset < ActiveRecord::Base
  TYPES = [
    ['Character', 'character'],
    ['Prop', 'prop'],
    ['Background', 'background'],
    ['Effect', 'effect'],
    ['Audio', 'audio'],
  ]

	has_paper_trail
  mount_uploader :asset, AssetUploader
  mount_uploader :preview, AssetUploader

  has_and_belongs_to_many :scene
  has_many :reel_assets, :dependent => :delete_all

  acts_as_taggable_on :keywords, :name

  attr_accessible :description,
                  :asset_type,
                  :name_list,
                  :keyword_list,
                  :asset,
                  :preview,
                  :scene_ids,
                  :stock

  #before_create :parse_meta

  def parse_meta
    newAsset = File.basename(self.asset.to_s)
    leftover, filename, extension = newAsset.split(/^(.*)\.(.*)$/)
    elements = filename.split('_')

    if elements[-1].match(/[0-9]/)
      self.id = elements[-1]
      elements.pop
    end


    self.stock = elements[0].downcase == 'stk' ? true : false
    if Asset::TYPES.map {|type| type[1] }.include?(elements[1])
      self.asset_type = elements[1]
      elements.shift
    end
    self.name_list = elements[1]
    self.keyword_list = elements[2..-1].join(', ')
    #newAsset['id'] = id if id
  end

  def title
    self.filename
  end

  def filename
    filename = []
    if self.stock?
      filename << 'STK'
    elsif self.scene_ids.length > 0
      Episode.joins(:scenes).where(:scenes => { :id => self.scene.map {|item| item.id} }).uniq.order("episodes.number ASC").each do |episode|
        filename << 'EP' + episode.number.pad
      end
    end
    filename += [self.asset_type] if self.asset_type
    filename += self.name_list.to_a + self.keyword_list.to_a + [self.id]
    puts filename.inspect
    filename = filename.join('_')
    filename += File.extname self.asset_url
    #filename.downcase
  end
end
