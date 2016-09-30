class WorkoutsController < ApplicationController
  load_and_authorize_resource

  # GET /workouts
  def index
    @workouts = current_user.workouts.desc(:workout_on)
    if params[:tag]
      @workouts = @workouts.where(tags: /#{params[:tag]}/)
      @tag = params[:tag]
    end
    if params[:q]
      @workouts = @workouts.where(location: /#{params[:q]}/i)
    end
    @workouts = @workouts.page(params[:page])
    @workout_summary = Workout.summary(current_user,31)
    @workout_duration_by_tag = Workout.workout_duration_by_tag(current_user,31)
  end

  # GET /workouts/1.js
  def show
  end

  # GET /workouts/new.js
  def new
    @types = Lookup.where(category: 2).all
    @routes = Lookup.where(category: 25).all
    if (params[:workout_id])
      @workout = Workout.find(params[:workout_id]).dup
    end
  end

  # GET /workouts/1/edit.js
  def edit
    @types = Lookup.where(category: 2).all
    @routes = Lookup.where(category: 25).all
  end

  # POST /workouts
  def create
    @workout = current_user.workouts.build(workout_params)
    if @workout.save
      current_user.tag('workout', @workout.tags)
      flash[:notice] = 'workout was created.'
      redirect_to workouts_path
    end
  end

  # PUT /workouts/1
  def update
    @workout = current_user.workouts.find(params[:id])
    if @workout.update_attributes!(workout_params)
      current_user.tag('workout', @workout.tags)
      flash[:notice] = 'workout was updated.'
      redirect_to workouts_path
    end
  end

  # DELETE /workouts/1
  def destroy
    @workout.destroy
    redirect_to workouts_path
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def workout_params
    params.require(:workout).permit(:location, :race, :description, :tags, :duration, :intensity, :weight, :distance, :workout_on, :route_id)
  end
end
