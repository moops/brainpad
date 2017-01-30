class MilestonesController < ApplicationController

  # GET /milestones
  def index
    authorize Milestone
    @milestones = current_user.milestones.desc(:milestone_at)
    if params[:q]
      @milestones = @milestones.where(name: /#{params[:q]}/i)
    end
    @milestones = @milestones.page(params[:page])
  end

  # GET /milestones/1.js
  def show
    @milestone = Milestone.find(params[:id])
    authorize @milestone
  end

  # GET /milestones/1/new.js
  def new
    @milestone = (params[:milestone_id]) ? Milestone.find(params[:milestone_id]).dup : Milestone.new
    authorize @milestone
  end

  # GET /milestones/1/edit.js
  def edit
    @milestone = Milestone.find(params[:id])
    authorize @milestone
  end

  # POST /milestones.js
  def create
    @milestone = current_user.milestones.build(milestone_params)
    authorize @milestone
    if @milestone.save
      @milestones = current_user.milestones.desc(:milestone_at).page(params[:page])
      flash[:notice] = "milestone #{@milestone.name} was created."
    end
  end

  # PUT /milestones/1.js
  def update
    @milestone = Milestone.find(params[:id])
    authorize @milestone
    if @milestone.update_attributes(milestone_params)
      @milestones = current_user.milestones.desc(:milestone_at).page(params[:page])
      flash[:notice] = "milestone #{@milestone.name} was updated."
    end
  end

  # DELETE /milestones/1
  def destroy
    @milestone = Milestone.find(params[:id])
    authorize @milestone
    @milestone.destroy
    redirect_to milestones_url
  end

  private

  def milestone_params
    params.require(:milestone).permit(:name, :milestone_at)
  end
end
