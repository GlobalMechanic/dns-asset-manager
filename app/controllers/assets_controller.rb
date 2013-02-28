class AssetsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :add_reels
  load_and_authorize_resource
  autocomplete :tag, :name, :class_name => 'ActsAsTaggableOn::Tag', :full => true

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
    @asset.parse_meta
    if @asset.id? && Asset.exists?(@asset.id)
      @asset = Asset.find(@asset.id)
      success = @asset.update_attributes(params[:asset])
    else
      success = @asset.save
    end

    respond_to do |format|
      if success
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
    @search = Asset.where(:asset_type => params[:asset_type]).search(params[:search])
    @assets = @search.all.uniq
    @title = params[:asset_type].titleize.pluralize + ' (' + @assets.count.to_s + ')'
    render 'index'
  end

  def keyword
    @assets = Asset.tagged_with(params[:keyword])
    @title = 'Tag: "' + params[:keyword] + '" (' + @assets.count.to_s + ')'
    render 'index'
  end

  def download
    @asset = Asset.find(params[:asset_id])
    if Rails.env.development?
      send_file File.join(Rails.root, 'public', @asset.asset_url), :filename => @asset.filename
    else
      open(@asset.asset_url) {|img|
        tmpfile = Tempfile.new(@asset.filename)
        File.open(tmpfile.path, 'wb') do |f|
          f.write img.read
        end
        send_file tmpfile.path, :filename => @asset.filename
      }
    end
  end

end
