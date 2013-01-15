class Clip < ActiveRecord::Base
	has_paper_trail

  acts_as_taggable_on :keywords, :techniques

  # If we need to access reels through clips.
  #has_many :reel_clips
  #has_many :reels, :through => :reel_clips

  attr_accessible :description,
                  :title,
                  :video,
                  :image,
                  :director,
                  :agency,
                  :client,
                  :year, 
                  :month,
                  :active,
                  :category,
                  :legacy_id

  validates :title, :presence => true,
                    :length => { :minimum => 5 }
end
