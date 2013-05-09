class AssetsController < ApplicationController
  before_filter :authenticate_user!, :except => [:download]
  before_filter :add_reels
  load_and_authorize_resource :except => [:download]
  autocomplete :tag, :keywords, { :column_name => 'name', :class_name => 'ActsAsTaggableOn::Tag', :full => true, :where => "(select context from taggings where tag_id = tags.id and context = 'keywords' group by context) = 'keywords'" }
  autocomplete :tag, :name, { :column_name => 'name', :class_name => 'ActsAsTaggableOn::Tag', :full => true, :where => "(select context from taggings where tag_id = tags.id and context = 'name' group by context) = 'name'" }

  # GET /assets
  # GET /assets.json
  def index
    if params[:search]
      @assets = Asset.find_with_index(params[:search])
      @title = "Search: #{params[:search]} (#{@assets.count})"
    else
      @assets = Asset.joins('LEFT OUTER JOIN "assets_scenes" ON "assets_scenes"."asset_id" = "assets"."id" LEFT OUTER JOIN "scenes" ON "scenes"."id" = "assets_scenes"."scene_id"').where(:assets_scenes => { :scene_id => nil })
      @title = "All Assets (#{@assets.count})"
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
    @title = 'New Asset'
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @asset }
    end
  end

  # GET /assets/1/edit
  def edit
    @asset = Asset.find(params[:id])
    @title = @asset.title
  end

  # POST /assets
  # POST /assets.json
  def create
    @asset = Asset.new(params[:asset])
    @asset.parse_meta
    if @asset.id? && Asset.exists?(@asset.id)
      @asset = Asset.find(@asset.id)
      @asset.user_id = nil
      @asset.submitted = true
      @asset.revision = false
      @asset.approved = false
      @asset.checked_out = false
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
        format.html { redirect_to edit_asset_path(@asset), notice: 'Asset was successfully updated.' }
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

  def queue
    @assets = current_user.assets
    @title = "My Qeueue (#{@assets.length})"
    render 'index'
  end

  def type
    @assets = Asset.where(:asset_type => params[:asset_type])
    @title = "#{params[:asset_type].titleize.pluralize} (#{@assets.count})"
    render 'index'
  end

  def keyword
    @assets = Asset.tagged_with(params[:keyword])
    @title = "Tag: #{params[:keyword]} (#{@assets.count})"
    render 'index'
  end

  def download
    @asset = Asset.find(params[:asset_id])
    if !ENV['S3_KEY'] || !ENV['S3_SECRET']
      send_file File.join(Rails.root, 'public', @asset.asset_url), :filename => @asset.filename
    else
      open('https://asset-manager.s3.amazonaws.com/uploads/asset/asset/' + @asset.id.to_s + '/' + File.basename(@asset.asset_url).to_s) {|img|
        tmpfile = Tempfile.new(@asset.filename)
        File.open(tmpfile.path, 'wb') do |f|
          f.write img.read
        end
        send_file tmpfile.path, :filename => @asset.filename
      }
    end
  end

  def checkout
    puts params.inspect
    @asset = Asset.find(params[:asset_id])
    if params[:download] == "true"
      redirect = asset_download_path(@asset)
    else
      redirect = request.referer
    end
    respond_to do |format|
      if @asset.update_attributes({ :user_id => current_user.id, :checked_out => true })
        format.html { redirect_to redirect, notice: 'Asset was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

end
