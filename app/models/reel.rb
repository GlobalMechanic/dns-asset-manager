class Reel < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title, :description

  has_many :reel_assets, :dependent => :delete_all
  has_many :assets, :through => :reel_assets

  self.primary_key = "slug"
  before_create :set_hash
 
  def set_hash
    self.slug = Digest::MD5.hexdigest(Time.now.to_s)
  end

end
