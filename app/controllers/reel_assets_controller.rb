class ReelAssetsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  # GET /reels/1/2
  # GET /reels/1/2.json
  def add
    @reel = Reel.find(params[:reel_id])
    next_order = @reel.reel_assets.length > 0 ? @reel.reel_assets.last.order.to_i + 1 : 0
    
    @asset = Asset.find(params[:asset_id])
    @reel_asset = @reel.reel_assets.new
    @reel_asset.asset_id = @asset.id
    @reel_asset.order = next_order

    # puts @reel_asset.inspect

    respond_to do |format|
      if @reel_asset.save
        format.html { redirect_to reel_path(@reel, :anchor => 'asset-' + @asset.id.to_s), notice: 'Reel was successfully updated.' }
        #format.json { head :no_content }
        format.json { render json: @reel.assets.length, status: :created, location: @reel }
      else
        format.html { render action: "edit" }
        format.json { render json: @reel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reels/1/2
  # PUT /reels/1/2.json
  def remove
    @reel = Reel.find(params[:reel_id])
    @asset = Asset.find(params[:asset_id])

    respond_to do |format|
      if @reel.assets.delete(@asset)
        format.html { redirect_to reel_path(@reel, :anchor => 'asset-' + @asset.id.to_s), notice: 'Reel was successfully updated.' }
        format.json { render json: @reel.assets.length, status: :created, location: @reel }
      else
        format.html { render action: "edit" }
        format.json { render json: @reel.errors, status: :unprocessable_entity }
      end
    end
  end

end
