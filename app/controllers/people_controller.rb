class PeopleController < ApplicationController
  
  load_and_authorize_resource

  # GET /people/new.js
  def new
  end

  # GET /people/1/edit.js
  def edit
  end

  # POST /people.js
  def create
    @person.roles=(['user'])
    if @person.save
      session[:user_id] = @person.id
      redirect_to links_path, notice: "welcome #{@person.username}, thank you for signing up!"
    else
      render 'new'
    end
  end

  # PUT /people/1.js
  def update
    if @person.update_attributes(params[:person])
      redirect_to links_path, notice: "#{@person.username}'s profile updated."
    else
      render 'edit'
    end
  end
end
