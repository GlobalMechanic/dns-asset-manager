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
    @episode = Episode.includes(:scenes, :assets).find(params[:episode_id])
    assets = []
    @episode.scenes.each do |scene|
      if scene.assets.length > 0
        scene.assets.each do |asset|
          assets << asset
        end
      end
    end
    t = Tempfile.new("temp-episode-zip-#{Time.now.strftime("%Y-%m-%d-%H-%M")}")
    Zip::ZipOutputStream.open(t.path) do |z|
      assets.each do |asset|
        z.put_next_entry(asset.filename)
        Kernel::open('https://asset-manager.s3.amazonaws.com/uploads/asset/asset/' + asset.id.to_s + '/' + File.basename(asset.preview_swf_url).to_s) {|file|
          z.print file.read
        }
      end
    end
    send_file t.path, :type => 'application/zip', :disposition => 'attachment', :filename => "1#{@episode.number.pad}_assets_#{Time.now.strftime("%Y-%m-%d-%H-%M")}.zip"
    t.close
  end

  protected
  def collection
    @episodes = end_of_association_chain.order('number')
    @title = "All Worlds (#{ @episodes.length })"
  end
end
