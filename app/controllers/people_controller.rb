class PeopleController < ApplicationController
  
  load_and_authorize_resource

  # GET /people/1
  # GET /people/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.json
  def new
    
    respond_to do |format|
      format.html # new.html.erb
      format.js 
    end
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.xml
  def create
    @person.roles=(['user'])
    if @person.save
      session[:user_id] = @person.id
      redirect_to links_path, notice: "welcome #{@person.username}, thank you for signing up!"
    else
      render "new"
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update

    respond_to do |format|
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Person was successfully updated.'
        format.html { redirect_to(@person) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end
end
