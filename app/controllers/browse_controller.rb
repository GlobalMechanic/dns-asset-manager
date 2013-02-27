class BrowseController < ApplicationController
  load_and_authorize_resource

   def type
    @assets = Asset.find_all_by_asset_type(params[:asset_type])
    @layout = params[:layout]

    render 'assets/index'
   end

end
