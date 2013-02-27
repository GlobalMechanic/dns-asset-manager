class Episode < ActiveRecord::Base
  #has_many :assets, :through => :reel_assets
  attr_accessible :number, :title, :season
  has_many :scenes
  validates :season, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :number, :numericality => { :only_integer => true, :greater_than => 0 }
end
