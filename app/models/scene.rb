class Scene < ActiveRecord::Base
  belongs_to :episode
  has_many :assets
  
  attr_accessible :number
end
