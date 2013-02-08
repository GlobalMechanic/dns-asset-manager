class BrowseController < ApplicationController

   def type
    @assets = Asset.find_all_by_asset_type(params[:asset_type])
    @layout = params[:layout]

    reel_me

    render 'assets/index'
   end

   private
   def reel_me
     if @current_reel
        @reel = @current_reel
      else
        @reel = current_user.reels.create
        current_user.current_reel_slug = @reel.id
        current_user.save
        @current_reel = @reel
      end
    end

end
