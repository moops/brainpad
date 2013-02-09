class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  after_filter :store_last_good_page
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = "Access denied."
    redirect_to login_path, :format => :js
   # render :action => '/sessions/new', 
    #       :content_type => 'application/javascript',
    #       :layout => false
  end
  
  def store_last_good_page
    session[:last_good_page] = request.fullpath
    flash[:notice] = "last good page: #{session[:last_good_page]}"
  end
  
  private
  
  def current_user
    @current_user ||= Person.find(session[:user_id]) if session[:user_id]
  end
end
