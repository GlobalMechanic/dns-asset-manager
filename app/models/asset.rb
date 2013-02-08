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

  has_many :reel_assets, :dependent => :delete_all

  acts_as_taggable_on :keywords

  attr_accessible :description,
                  :title,
                  :season,
                  :episode,
                  :scene,
                  :shot,
                  :category,
                  :asset_type,
                  :keyword_list,
                  :asset

  #validates_inclusion_of :type, :in => TYPES

 before_create :default_name
  
  def default_name
    self.title ||= File.basename(asset.filename, '.*') if asset
  end
end
