class SessionsController < ApplicationController

  # GET /sessions/new.js
  def new; end

  # login
  # POST /sessions.js
  def create
    user = Person.find_by(username: params[:username])

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
    redirect_to root_url, notice: 'Logged out!'
  end
end
