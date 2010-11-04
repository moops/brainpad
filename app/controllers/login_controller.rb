class LoginController < ApplicationController
    
  layout 'standard.html'
    
  def index
    # show login screen
  end

  def authenticate
    
    if APP_CONFIG['authenticate']
      logger.debug("LoginController.authenticate: authenticating...")
      user = Person.authenticate(params[:person][:user_name], params[:person][:password])
    else #not authenticating, just use the param as the user_name
      logger.debug("LoginController.authenticate: using user_name param...")
      user = Person.find_by_user_name(params[:person][:user_name])
    end

    if user
      logger.debug("LoginController.authenticate: user authenticated[#{user.inspect}]")
      session[:user] = user
      if session[:return_to]
        temp = session[:return_to]
        session[:return_to] = nil
        redirect_to(temp)
      else
        redirect_to links_path
      end
    else
      flash[:notice] = 'Login failed!' 
      redirect_to :action => 'index'
    end
  end

  def logout
    reset_session
    flash[:notice] = 'Logged out' 
    redirect_to :action => 'index' 
  end
  
end
