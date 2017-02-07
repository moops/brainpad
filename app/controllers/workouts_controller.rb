# require 'strava/api/v3'

class WorkoutsController < ApplicationController

  # GET /workouts
  def index
    authorize Workout
    # fill in recent workouts from strava activities
    # TODO how far back do we look in the strava stream? 20 for now
    created_from_strava = Brainpad::StravaLib.import_for(current_user, 20)
    flash[:notice] = "created #{created_from_strava} new workouts from strava" if created_from_strava > 0

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
    @workout = Workout.find(params[:id])
    authorize @workout
  end

  # GET /workouts/new.js
  def new
    @routes = Lookup.where(category: 25).all
    @workout = params[:workout_id] ? @workout = Workout.find(params[:workout_id]).dup : Workout.new
  end

  # GET /workouts/1/edit.js
  def edit
    @workout = Workout.find(params[:id])
    authorize @workout
    @routes = Lookup.where(category: 25).all
  end

  # POST /workouts
  def create
    @workout = current_user.workouts.build(workout_params)
    authorize @workout
    if @workout.save
      current_user.tag('workout', @workout.tags)
      flash[:notice] = 'workout was created.'
      redirect_to workouts_path
    end
  end

  # PUT /workouts/1
  def update
    @workout = Workout.find(params[:id])
    authorize @workout
    if @workout.update_attributes!(workout_params)
      current_user.tag('workout', @workout.tags)
      flash[:notice] = 'workout was updated.'
      redirect_to workouts_path
    end
  end

  # DELETE /workouts/1
  def destroy
    @workout = Workout.find(params[:id])
    authorize @workout
    @workout.destroy
    redirect_to workouts_path
  end

  private

  def workout_params
    params.require(:workout).permit(:location, :race, :description, :tags, :duration, :intensity, :weight, :distance, :workout_on, :route_id, :strava_id)
  end
end
