class SessionsController < ApplicationController
  
  # GET /sessions/new
  def new
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  # login
  # POST /sessions.js
  def create
    user = Person.where(username: params[:username]).first

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "logged in as #{user.username}"
      redirect_to links_path
    else
      flash[:warning] = 'who are you talking about?'
      redirect_to root_path
    end
  end
  
  # logout
  # DELETE /sessions/1
  # DELETE /sessions/1.js
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
