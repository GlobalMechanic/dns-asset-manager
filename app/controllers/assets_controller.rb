class AssetsController < ApplicationController
  before_filter :authenticate_user!

  # GET /assets
  # GET /assets.json
  def index
    @search = Asset.search(params[:search])

    if !params[:search]
      @title = 'All Assets (' + Asset.count.to_s + ')'
    elsif params[:where]
      search_terms = params[:search].values.reject(&:blank?)
      if !search_terms.empty?
        @title = params[:where].titleize + ': "' + search_terms.join(', ') + '"'
      end
    end

    if ['director', 'client', 'category'].include? params[:where]
      @assets = @search.order('LOWER(' + params[:where] + ') ASC, title ASC')
    elsif ['technique', 'keyword'].include? params[:where]
      @assets = @search.order('title').uniq  
    else
      @assets = @search.order('created_at DESC')
    end

    if @current_reel
      @reel = @current_reel
    else
      @reel = current_user.reels.create
      current_user.current_reel_slug = @reel.id
      current_user.save
      @current_reel = @reel
    end
    
    # per_page = 20
    # @assets = Asset.limit(per_page).offset(params[:page] ? params[:page].to_i * per_page : 0)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @assets }
    end
  end

  # GET /assets/1
  # GET /assets/1.json
  def show
    @asset = Asset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @asset }
    end
  end

  # GET /assets/new
  # GET /assets/new.json
  def new
    @asset = Asset.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @asset }
    end
  end

  # GET /assets/1/edit
  def edit
    @asset = Asset.find(params[:id])
  end

  # POST /assets
  # POST /assets.json
  def create
    @asset = Asset.new(params[:asset])

    respond_to do |format|
      if @asset.save
        format.html { redirect_to @asset, notice: 'Asset was successfully created.' }
        format.json { render json: @asset, status: :created, location: @asset }
      else
        format.html { render action: "new" }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /assets/1
  # PUT /assets/1.json
  def update
    @asset = Asset.find(params[:id])

    respond_to do |format|
      if @asset.update_attributes(params[:asset])
        format.html { redirect_to @asset, notice: 'Asset was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.json
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to assets_url }
      format.json { head :no_content }
    end
  end

  def batch
    respond_to do |format|
      format.html { render json: params }
      format.json { render json: params }
    end
  end

  def type
    @assets = Asset.find_all_by_asset_type(params[:asset_type])
    @title = params[:asset_type].titleize.pluralize
    render 'index'
  end

  def keyword
    @assets = Asset.tagged_with(params[:keyword])
    @title = 'Tag: "' + params[:keyword] + '"'
    render 'index'
  end
end
