class Reel < ActiveRecord::Base
  #resourcify
  belongs_to :user
  attr_accessible :title, :description

  has_many :reel_clips, :dependent => :delete_all
  has_many :clips, :through => :reel_clips

  self.primary_key = "slug"
  before_create :set_hash
 
  def set_hash
    self.slug = Digest::MD5.hexdigest(Time.now.to_s)
  end

end
