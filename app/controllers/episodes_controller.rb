class EpisodesController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource
  before_filter :authenticate_user!
  before_filter :add_reels

  def show
    super do |format|
      @title = "Designs - #{ @episode.number.pad } - #{ @episode.title } (#{ @episode.assets.length })"
    end
  end

  protected
  def collection
    @episodes = end_of_association_chain.order('number')
    @title = "All Worlds (#{ @episodes.length })"
  end
end
