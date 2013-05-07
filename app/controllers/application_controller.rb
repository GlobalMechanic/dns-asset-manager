class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :page_variables

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to request.referer || root_path, :alert => exception.message
  end

  def redirect
    if current_user.has_role?(:animator)
      redirect_to episodes_path
    else
      redirect_to assets_path
    end
  end

  private
  def page_variables
    @current_reel = current_user && current_user.current_reel_slug? && Reel.exists?(current_user.current_reel_slug) ? Reel.find(current_user.current_reel_slug) : nil
    @reels_created = Reel.accessible_by(current_ability, :edit).where("title <> ''").order('created_at DESC').limit(5)
    @reels_updated = Reel.accessible_by(current_ability, :edit).where("title <> ''").order('updated_at DESC').limit(5)
    if params[:layout] == 'grid' || params[:layout] == 'list'
      session[:layout] = params[:layout]
    end
    @layout = session[:layout] ? session[:layout] : 'grid'
    puts session.inspect
  end

  def add_reels
    if current_user != nil
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

end
