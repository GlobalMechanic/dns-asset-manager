class ReelsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  load_and_authorize_resource :except => [:show]

  # GET /reels
  # GET /reels.json
  def index
    @reels = Reel.accessible_by(current_ability, :edit).where("title <> ''").order('created_at DESC').page(params[:page]).per(params[:number])
    @title = 'All Reels (' + @reels.count.to_s + ')'

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reels }
    end
  end

  # GET /reels/1
  # GET /reels/1.json
  def show
    @reel = Reel.find(params[:id])
    @assets = @reel.assets.order('"order"')
    @title = @reel.title
    
    respond_to do |format|
      format.html # show.html
      format.json { render json: @reel }
    end
  end

  # POST /reels/1/sort.json
  def sort
    params[:order].each_with_index do |id, index|
      @reel_asset = ReelAsset.find_by_reel_id_and_asset_id(params[:id], id.to_i)
      @reel_asset.order = index
      @reel_asset.save
    end

    respond_to do |format|
      format.json { render json: true }
    end
    
  end

  def close
    current_user.current_reel_slug = nil
    respond_to do |format|
      if current_user.save
        format.html { redirect_to assets_url }
        format.json { head :no_content }
      else
        format.html { redirect_to assets_url, notice: 'For some reason the reel wouldn\'t close. <a href="/reels">Open a new one?</a>'.html_safe }
        format.json { render json: "Couldn't close reel.", status: :unprocessable_entity }
      end
    end
  end

  def open
    # @reel = Reel.find(params[:id])
    set_current_reel_slug params[:id]
    respond_to do |format|
      format.html { redirect_to edit_reel_path params[:id] }
      format.json { render json: @reel }
    end
  end

  def download
    @reel = Reel.find(params[:id])
    t = Tempfile.new("temp-reel-zip-#{Time.now.strftime("%Y-%m-%d-%H-%M")}")
    Zip::ZipOutputStream.open(t.path) do |z|
      @reel.assets.each do |asset|
        z.put_next_entry(asset.filename)
        Kernel::open('https://asset-manager.s3.amazonaws.com/uploads/asset/asset/' + asset.id.to_s + '/' + File.basename(asset.asset_url).to_s) {|img|
          z.print img.read
        }
      end
    end
    item_text = @reel.assets.length > 1 ? 'items' : 'item'
    send_file t.path, :type => 'application/zip', :disposition => 'attachment', :filename => "plum_landing_#{Time.now.strftime("%m-%d-%H-%M")}_#{@reel.assets.length}_#{item_text}.zip"
    t.close
  end


  # GET /reels/new
  # GET /reels/new.json
  def new
    @reel = current_user.reels.new
    #@reel.user = current_user
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reel }
    end
  end

  # GET /reels/1/edit
  def edit
    @reel = Reel.find(params[:id])
    @assets = @reel.assets.order('"order"')
    set_current_reel_slug @reel.id
  end

  # POST /reels
  # POST /reels.json
  def create
    @reel = current_user.reels.new(params[:reel])
    @reel.save
    set_current_reel_slug @reel.id
   # @reel.user = current_user
    respond_to do |format|
      if current_user.save
        format.html { redirect_to @reel, notice: 'Reel was successfully created.' }
        format.json { render json: @reel, status: :created, location: @reel }
      else
        format.html { render action: "new" }
        format.json { render json: @reel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reels/1
  # PUT /reels/1.json
  def update
    @reel = Reel.find(params[:id])
    title = @reel.title?
    if title
      notice = 'Reel was successfully updated.'
    else
      @reel.created_at = Time.now
      notice = 'Reel was successfully created.'
    end
    respond_to do |format|
      if @reel.update_attributes(params[:reel])
        format.html { redirect_to edit_reel_path(@reel), notice: notice }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reels/1
  # DELETE /reels/1.json
  def destroy
    @reel = Reel.find(params[:id])
    @reel.destroy

    @blank_reel = current_user.reels.new(params[:reel])
    @blank_reel.save
    set_current_reel_slug @blank_reel.id

    respond_to do |format|
      format.html { redirect_to reels_url }
      format.json { head :no_content }
    end
  end

  private
  def set_current_reel_slug(reel_slug)
    current_user.current_reel_slug = reel_slug
    current_user.save
  end

end
