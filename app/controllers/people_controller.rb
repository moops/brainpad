class PeopleController < ApplicationController

  # GET /people/new.js
  def new
    @person = Person.new
  end

  # GET /people/1/edit.js
  def edit
    @person = Person.find(params[:id])
    authorize @person
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
        format.js { p 'good js request'; render action: 'new', notice: "js welcome #{@person.username}, thank you for signing up!" }
      else
        format.js { render action: 'new', notice: "#{@person.errors.messages}" }
        format.html { render action: 'new', notice: "#{@person.errors.messages}" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /people/1.js
  def update
    @person = Person.find(params[:id])
    authorize @person
    if @person.update_attributes(person_params)
      redirect_to links_path, notice: "#{@person.username}'s profile updated."
    else
      render :edit
    end
  end

  # DELETE /people/1
  def destroy
    @person = Person.find(params[:id])
    authorize @person
    @person.destroy
    redirect_to root_url, notice: "#{@person.username} removed"
  end

  private

  def person_params
    params.require(:person).permit(
      :username, :email, :password, :password_confirmation, :roles, :born_on, :phone
    )
  end
end
