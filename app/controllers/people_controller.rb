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
    @person = Person.new(person_params)
    @person.roles=(['user'])
    respond_to do |format|
      if @person.save
        format.html {
          session[:user_id] = @person.id
          redirect_to links_path, notice: "welcome #{@person.username}, thank you for signing up!"
        }
        format.json { render action: 'show', status: :created, location: @person }
      else
        format.js { render action: 'new' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /people/1.js
  def update
    if @person.update_attributes(person_params)
      redirect_to links_path, notice: "#{@person.username}'s profile updated."
    else
      render 'edit'
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def person_params
    params.require(:person).permit(
      :username, :email, :password, :password_confirmation, :roles, :born_on, :phone
    )
  end
end
