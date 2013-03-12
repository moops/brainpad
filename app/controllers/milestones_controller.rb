class MilestonesController < ApplicationController

  load_and_authorize_resource
  
  # GET /milestones
  def index    
    @milestones = current_user.milestones.desc(:milestone_at)
    if params[:q]
      @milestones = @milestones.where(name: /#{params[:q]}/i)
    end
    @milestones = @milestones.page(params[:page])
  end

  # GET /milestones/1.js
  def show
  end
  
  # GET /milestones/1/new.js
  def new
    if (params[:milestone_id])
      @milestone = Milestone.find(params[:milestone_id]).dup
    end
  end
  
  # GET /milestones/1/edit.js
  def edit
  end

  # POST /milestones.js
  def create
    @milestone = current_user.milestones.build(params[:milestone])
    if @milestone.save
      @milestones = current_user.milestones.desc(:milestone_at).page(params[:page])
      flash[:notice] = "milestone #{@milestone.name} was created."
    end
  end

  # PUT /milestones/1.js
  def update
    @milestone = current_user.milestones.find(params[:id])
    if @milestone.update_attributes(params[:milestone])
      @milestones = current_user.milestones.desc(:milestone_at).page(params[:page])
      flash[:notice] = "milestone #{@milestone.name} was updated."
    end
  end

  # DELETE /milestones/1
  def destroy
    @milestone.destroy
    redirect_to milestones_url
  end
end