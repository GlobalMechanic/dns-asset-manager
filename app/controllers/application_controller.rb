class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :page_variables

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to request.referer || root_path, :alert => exception.message
  end

  private
  def page_variables
    @current_reel = current_user && current_user.current_reel_slug? && Reel.exists?(current_user.current_reel_slug) ? Reel.find(current_user.current_reel_slug) : nil
    @reels_created = Reel.where("title <> ''").order('created_at DESC').limit(5)
    @reels_updated = Reel.where("title <> ''").order('updated_at DESC').limit(5)

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
