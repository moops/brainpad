class WorkoutsController < ApplicationController
  
  load_and_authorize_resource
  
  # GET /workouts
  def index    
    @workouts = current_user.workouts.desc(:workout_on)
    if params[:q]
      @workouts = @workouts.where(location: /#{params[:q]}/i)
    end
    @workouts = @workouts.page(params[:page])
    
    @workout_summary = Workout.summary(@current_user,31)
    @workout_duration_by_type = Workout.workout_duration_by_type(current_user,31)
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

  # POST /workouts
  def create
    if @workout.save
      flash[:notice] = 'workout was created.'
      redirect_to workouts_path
    end
  end

  # PUT /workouts/1
  def update
    if @workout.update_attributes!(params[:workout])
      flash[:notice] = 'workout was updated.'
      redirect_to workouts_path
    end
  end

  # DELETE /workouts/1
  def destroy
    @workout.destroy
    redirect_to workouts_path
  end
end