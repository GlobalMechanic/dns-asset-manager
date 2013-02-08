class BrowseController < ApplicationController

   def type
    @assets = Asset.find_all_by_asset_type(params[:asset_type])
    @title = params[:layout]

    if @current_reel
      @reel = @current_reel
    else
      @reel = current_user.reels.create
      current_user.current_reel_slug = @reel.id
      current_user.save
      @current_reel = @reel
    end

    render 'assets/index'
   end

end
