class WorkoutsController < ApplicationController
  
  before_filter :authenticate
  layout 'standard.html', :except => [:show, :edit]
  
  # GET /workouts
  # GET /workouts.xml
  def index    
    @user = Person.find(session[:user_id])
    @workouts = Workout.paginate :page => params[:page], :conditions => "person_id = #{session[:user_id]}", :order => 'workout_on desc', :per_page => 10

    @workout = Workout.new #for the 'new' form
    @workout.workout_on = Date.today.strftime("%b %d, %Y")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @workouts }
    end
  end

  # GET /workouts/1
  # GET /workouts/1.xml
  def show
    @workout = Workout.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @workout }
    end
  end

  # GET /workouts/new
  # GET /workouts/new.xml
  def new
    @workout = Workout.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @workout }
    end
  end

  # GET /workouts/1/edit
  def edit
    @workout = Workout.find(params[:id])
  end

  # POST /workouts
  # POST /workouts.xml
  def create
    @workout = Workout.new(params[:workout])

    respond_to do |format|
      if @workout.save
        flash[:notice] = 'Workout was successfully created.'
        format.html { redirect_to(workouts_path) }
        format.xml  { render :xml => @workout, :status => :created, :location => @workout }
      else
        format.html { redirect_to(workouts_path) }
        format.xml  { render :xml => @workout.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /workouts/1
  # PUT /workouts/1.xml
  def update
    @workout = Workout.find(params[:id])

    respond_to do |format|
      if @workout.update_attributes(params[:workout])
        flash[:notice] = 'Workout was successfully updated.'
        format.html { redirect_to(workouts_path) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(workouts_path) }
        format.xml  { render :xml => @workout.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /workouts/1
  # DELETE /workouts/1.xml
  def destroy
    @workout = Workout.find(params[:id])
    @workout.destroy

    respond_to do |format|
      format.html { redirect_to(workouts_url) }
      format.xml  { head :ok }
    end
  end
end
