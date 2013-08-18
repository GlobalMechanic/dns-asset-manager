class EpisodesController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource
  before_filter :authenticate_user!
  before_filter :add_reels

  def show
    super do |format|
      @assets = @episode.assets.joins('LEFT OUTER JOIN "assets_scenes" ON "assets_scenes"."asset_id" = "assets"."id" LEFT OUTER JOIN "scenes" ON "scenes"."id" = "assets_scenes"."scene_id"').where(:assets_scenes => { :scene_id => nil }).where('asset_type != ?', 'animatic').order('created_at DESC')
      @title = "Designs - #{ @episode.number.pad } - #{ @episode.title } (#{ @assets.length })"
    end
  end

  def download
    @episode = Episode.find(params[:episode_id])
    @episode.download_scenes_assets
    render json: true
  end

  protected
  def collection
    @episodes = end_of_association_chain.order('number')
    @title = "All Worlds (#{ @episodes.length })"
  end
end
