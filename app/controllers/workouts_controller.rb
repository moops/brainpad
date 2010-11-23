class WorkoutsController < ApplicationController
  
  before_filter :authorize
  layout 'standard.html', :except => :show
  
  # GET /workouts
  # GET /workouts.xml
  def index    
    @workouts = Workout.search({ :q => params[:q], :type => params[:type], :user => @user.id, :start_on => params[:start_on], :end_on => params[:end_on] }, params[:page])
    @workout = Workout.new #for the 'new' form
    
    @workout_summary = WorkoutSummary.new(@user,31)
    @workout_duration_by_type = Workout.workout_duration_by_type(@user,31)

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
      format.js { render :layout => false }
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
    respond_to do |format|
      format.html 
      format.js { render :layout => false }
    end
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

class WorkoutSummary

  attr_reader :workout_days, :mileage, :duration, :weight_range

  def initialize(user,days)
    workouts = Workout.recent_workouts(user,days)
    @mileage = 0
    @duration = 0
    max_weight = 0
    min_weight = 999
    for w in workouts
      @mileage += w.distance
      @duration += w.duration
      max_weight = w.weight if w.weight and w.weight > max_weight
      min_weight = w.weight if w.weight and w.weight < min_weight
    end
    @weight_range = "#{min_weight}-#{max_weight}"
    @workout_days = Workout.days_with_workouts?(user,days)
  end
    
end
