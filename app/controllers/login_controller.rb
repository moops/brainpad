require 'rexml/document'

class LoginController < ApplicationController
    
  layout 'standard.html'
    
  def index
    # show login screen
  end

  def authenticate
    @user = Person.authenticate(params[:person][:user_name], params[:person][:password])
    logger.info("@user: #{@user.inspect}")
    
    doc = REXML::Document.new(@user, 'user')
  
    
    logger.info("doc #{doc.inspect}")
    
    
  
    if @user
      session[:user_id] = Person.find_id_by_user_name(@user.user_name)
      if session[:return_to]
        temp = session[:return_to]
        session[:return_to] = nil
        redirect_to(temp)
      else
        redirect_to :controller => 'links', :action => 'index'
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
