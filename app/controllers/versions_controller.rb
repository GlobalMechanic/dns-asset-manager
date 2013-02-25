class VersionsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  # GET %/version/1
  # GET %/version/1.json
  def show
    @version = Version.find(params[:id])
    @version.object = YAML.load(@version.object).except('created_at', 'updated_at', 'id');
    @asset = Asset.new(@version.object)
    respond_to do |format|
      format.html { render :template => "assets/show" }
      format.json { render json: @version }
    end
  end

end
