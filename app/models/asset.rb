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

  has_and_belongs_to_many :scene
  has_many :reel_assets, :dependent => :delete_all

  acts_as_taggable_on :keywords, :characters

  attr_accessible :description,
                  :asset_type,
                  :character_list,
                  :keyword_list,
                  :asset,
                  :scene_ids,
                  :stock

  def title
    self.filename
  end

  def filename
    filename = ([self.asset_type] + self.character_list.to_a + self.keyword_list.to_a + [self.id]).join('_')
    filename += File.extname self.asset_url
    filename.downcase
  end
end
