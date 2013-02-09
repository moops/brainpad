class SessionsController < ApplicationController
  skip_after_filter :store_last_good_page
  
  # GET /sessions/new
  def new
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  # login
  # POST /sessions.js
  def create
    
    user = Person.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "logged in as #{user.username}"
      go_to = session[:last_good_page] || user_path(user)
    else
      flash[:warning] = 'who are you talking about?'
      go_to = session[:last_good_page] || root_url
    end

    redirect_to go_to

    # from photo app
    #user = User.find_by_email(params[:email])
    #if user && user.authenticate(params[:password])
    #  session[:user_id] = user.id
    #  redirect_to root_url, notice: "Logged in!"
    #else
    #  flash.now.alert = "Email or password is invalid"
    #  render "new"
    #end
  end
  
  # logout
  # DELETE /sessions/1
  # DELETE /sessions/1.js
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
