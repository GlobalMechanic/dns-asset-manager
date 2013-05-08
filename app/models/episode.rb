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
end
