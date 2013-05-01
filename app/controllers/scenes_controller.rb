class ScenesController < InheritedResources::Base
  belongs_to :episode
  respond_to :html, :json
  before_filter :authenticate_user!
  before_filter :add_reels
  load_and_authorize_resource

  protected
  def collection
    @scenes = end_of_association_chain.order('number')
  end
end
