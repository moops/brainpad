class LoginController < ApplicationController
    
  layout 'standard.html'
    
  def index
    # show login screen
  end

  def authenticate
    @user = Person.authenticate(params[:person][:user_name], params[:person][:password])
    logger.info("@user: #{@user.inspect}")
    if @user
      session[:user_id] = @user.id
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
