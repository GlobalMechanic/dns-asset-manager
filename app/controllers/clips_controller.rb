class ClipsController < ApplicationController
  before_filter :authenticate_user!

  # GET /clips
  # GET /clips.json
  def index
    @search = Clip.search(params[:search])

    if !params[:search]
      @title = 'All Clips (' + Clip.count.to_s + ')'
    elsif params[:where]
      search_terms = params[:search].values.reject(&:blank?)
      if !search_terms.empty?
        @title = params[:where].titleize + ': "' + search_terms.join(', ') + '"'
      end
    end

    if ['director', 'client', 'category'].include? params[:where]
      @clips = @search.order('LOWER(' + params[:where] + ') ASC, title ASC')
    elsif ['technique', 'keyword'].include? params[:where]
      @clips = @search.order('title').uniq  
    else
      @clips = @search.order('created_at DESC')
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
    # @clips = Clip.limit(per_page).offset(params[:page] ? params[:page].to_i * per_page : 0)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clips }
    end
  end

  # GET /clips/1
  # GET /clips/1.json
  def show
    @clip = Clip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @clip }
    end
  end

  # GET /clips/new
  # GET /clips/new.json
  def new
    @clip = Clip.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @clip }
    end
  end

  # GET /clips/1/edit
  def edit
    @clip = Clip.find(params[:id])
  end

  # POST /clips
  # POST /clips.json
  def create
    @clip = Clip.new(params[:clip])

    respond_to do |format|
      if @clip.save
        format.html { redirect_to @clip, notice: 'Clip was successfully created.' }
        format.json { render json: @clip, status: :created, location: @clip }
      else
        format.html { render action: "new" }
        format.json { render json: @clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clips/1
  # PUT /clips/1.json
  def update
    @clip = Clip.find(params[:id])

    respond_to do |format|
      if @clip.update_attributes(params[:clip])
        format.html { redirect_to @clip, notice: 'Clip was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clips/1
  # DELETE /clips/1.json
  def destroy
    @clip = Clip.find(params[:id])
    @clip.destroy

    respond_to do |format|
      format.html { redirect_to clips_url }
      format.json { head :no_content }
    end
  end

  def batch
    respond_to do |format|
      format.html { render json: params }
      format.json { render json: params }
    end
  end
end
