class EpisodesController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource
  before_filter :authenticate_user!
  before_filter :add_reels

  protected
  def collection
    @episodes = end_of_association_chain.order('number')
  end
end
