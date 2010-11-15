# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def authorize
    if session[:user]
      @user = Person.find(session[:user].user_id)
      @user.auth_profile = session[:user]
      logger.debug("ApplicationController.authorize: @user[#{@user.inspect}]")
      logger.debug("ApplicationController.authorize: @user.auth_profile[#{@user.auth_profile.inspect}]")
    else
      session[:return_to] = request.request_uri
      redirect_to :controller => 'login' 
      return false
    end
  end
  
end
