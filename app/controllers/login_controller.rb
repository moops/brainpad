require 'rexml/document'

class LoginController < ApplicationController
    
  layout 'standard.html'
    
  def index
    # show login screen
  end

  def authenticate  
    if APP_CONFIG['authenticate'].eql?('true')
      user = Person.authenticate(params[:person][:user_name], params[:person][:password])
      if user.empty?
        user_name = nil
      else 
        user_name = REXML::Document.new(user).root.elements["user-name"].text
      end
    else #not authenticating, just use the param as the user_name
      user_name = params[:person][:user_name]
    end

    if user_name
      logger.debug("LoginController.authenticate: user_name[#{user_name}] authenticated")
      session[:user_id] = Person.find_id_by_user_name(user_name)
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
