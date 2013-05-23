class Scene < ActiveRecord::Base
  belongs_to :episode
  has_and_belongs_to_many :assets
  
  attr_accessible :number, :part, :episode_id
end
