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

  acts_as_taggable_on :keywords, :characters

  attr_accessible :description,
                  :asset_type,
                  :character_list,
                  :keyword_list,
                  :asset,
                  :preview,
                  :scene_ids,
                  :stock

 # before_create :default_name
  
 #  def default_name
 #    self.title ||= File.basename(asset.filename, '.*') if asset
 #  end

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
    filename += [self.asset_type] + self.character_list.to_a + self.keyword_list.to_a + [self.id]
    filename = filename.join('_')
    filename += File.extname self.asset_url
    #filename.downcase
  end
end
