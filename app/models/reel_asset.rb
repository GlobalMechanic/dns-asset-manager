class ReelAsset < ActiveRecord::Base
  attr_accessible :asset_id, :reel_slug, :order
  belongs_to :asset
  belongs_to :reel
end
