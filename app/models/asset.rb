class Asset < ActiveRecord::Base
	has_paper_trail
  mount_uploader :asset, AssetUploader

  has_many :reel_assets, :dependent => :delete_all

  acts_as_taggable_on :keywords, :techniques

  attr_accessible :description,
                  :title,
                  :season,
                  :episode,
                  :scene,
                  :shot,
                  :category,
                  :keyword_list,
                  :asset

 before_create :default_name
  
  def default_name
    self.title ||= File.basename(asset.filename, '.*') if asset
  end
end
