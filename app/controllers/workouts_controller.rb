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
    #get_lookups(params[:workout])
    #debugger
    #workout_type =  Lookup.find(params[:workout][:workout_type])
    @workout = Workout.new(params[:workout])
    #@workout.workout_type = workout_type unless workout_type.nil?
    if @workout.save
      @workouts = current_user.workouts.desc(:workout_on).page(params[:page])
      flash[:notice] = 'workout was created.'
    end
  end

  # PUT /workouts/1.js
  def update
    #p = get_lookups(params[:workout])
    if params[:workout][:workout_type].empty?
      params[:workout][:workout_type] = nil
    else
      params[:workout][:workout_type] = Lookup.find(params[:workout][:workout_type])
    end

    @workout = Workout.find(params[:id])
    logger.info("updating attributes with #{params[:workout].inspect}")
    if @workout.update_attributes!(params[:workout])
      #@workout.save
      #@workout.route = params[:workout][:route]
      logger.info("updated workout #{@workout.inspect}")
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

  private

  def get_lookups(p)
    logger.info("get_lookups with #{p.inspect}")
    debugger
    if p[:workout_type].empty?
      p[:workout_type] = nil
    else
      p[:workout_type] = Lookup.find(p[:workout_type])
    end

    if p[:route].empty?
      logger.info("setting route to nil")
      p[:route] = nil
    else
      p[:route] = Lookup.find(p[:route])
      logger.info("set route to #{Lookup.find(p[:route]).description}")
    end
    p
  end
end