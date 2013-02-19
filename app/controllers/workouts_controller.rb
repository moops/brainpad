class WorkoutsController < ApplicationController
  
  load_and_authorize_resource :except => [:create, :update]
  
  # GET /workouts
  def index    
    @workouts = @current_user.workouts.desc(:workout_on)
    if params[:q]
      @workouts = @workouts.where(location: /#{params[:q]}/i)
    end
    @workouts = @workouts.page(params[:page])
    
    @workout_summary = Workout.summary(@current_user,31)
    @workout_duration_by_type = Workout.workout_duration_by_type(@current_user,31)
  end

  # GET /workouts/1.js
  def show
  end

  # GET /workouts/new.js
  def new
    @types = Lookup.where(:category => 2).all
    @routes = Lookup.where(:category => 25).all
    if (params[:workout_id])
      @workout = Workout.find(params[:workout_id]).dup
    end
  end

  # GET /workouts/1/edit.js
  def edit
    @types = Lookup.where(:category => 2).all
    @routes = Lookup.where(:category => 25).all
  end

  # POST /workouts.js
  def create
    @workout = Workout.new(params[:workout])
    if @workout.save
      @workouts = current_user.workouts.desc(:workout_on).page(params[:page])
      flash[:notice] = 'workout was created.'
    end
  end

  # PUT /workouts/1.js
  def update
    @workout = Workout.find(params[:id])
    if @workout.update_attributes!(params[:workout])
      @workouts = current_user.workouts.desc(:workout_on).page(params[:page])
      flash[:notice] = 'workout was updated.'
    else
      logger.info("WTF?")
    end
  end

  # DELETE /workouts/1
  def destroy
    @workout.destroy
    redirect_to(workouts_path)
  end
end