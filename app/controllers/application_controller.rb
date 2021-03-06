class ApplicationController < ActionController::Base
  # use has_mobile_fu(true) to force mobile view rendering
  has_mobile_fu

  helper :all # include all helpers, all the time

  # make methods available to views
  helper_method :logged_in?, :current_user_session, :current_user

  # See ActionController::RequestForgeryProtection for details
  protect_from_forgery

  before_filter { |c| Authorization.current_user = c.current_user}
  before_filter :set_time_zone
  before_filter :require_user

  # rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def logged_in?
    !current_user_session.nil?
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end


  def set_time_zone
    Time.zone = 'Mountain Time (US & Canada)'
  end

#  def render_404
#    render :template => "layouts/error_404", :status => "404 Not Found"
#  end

private

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      redirect_to private_home_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.url
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

protected
  def permission_denied
    flash[:error] = "Sorry, you are not allowed to access that page."
    redirect_to private_home_url
  end
end
