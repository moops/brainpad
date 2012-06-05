class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  after_filter :store_last_good_page
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = "Access denied."
    redirect_to login_path
  end
  
  def store_last_good_page
    session[:last_good_page] = request.fullpath
    flash[:notice] = "last good page: #{session[:last_good_page]}"
  end
  
  private
  
  def current_user
    @current_user_session ||= Session.find(session[:user_session]) if session[:user_session]
    @current_user ||= @current_user_session.user.id if @current_user_session and @current_user_session.user
  end
end
