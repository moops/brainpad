class MilestonesController < ApplicationController
  before_action :set_milestone, only: %i[show edit update destroy]

  # GET /milestones
  def index
    authorize Milestone
    @milestones = current_user.milestones.desc(:milestone_at)
    @milestones = @milestones.where(name: /#{params[:q]}/i) if params[:q]
    @milestones = @milestones.page(params[:page])
  end

  # GET /milestones/1.js
  def show
    authorize @milestone
  end

  # GET /milestones/1/new.js
  def new
    @milestone = params[:milestone_id] ? Milestone.find(params[:milestone_id]).dup : Milestone.new
    authorize @milestone
  end

  # GET /milestones/1/edit.js
  def edit
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
    authorize @milestone
    if @milestone.update_attributes(milestone_params)
      @milestones = current_user.milestones.desc(:milestone_at).page(params[:page])
      flash[:notice] = "milestone #{@milestone.name} was updated."
    end
  end

  # DELETE /milestones/1
  def destroy
    authorize @milestone
    @milestone.destroy
    redirect_to milestones_url
  end

  private

  def set_milestone
    @milestone = Milestone.find(params[:id])
  end

  def milestone_params
    params.require(:milestone).permit(:name, :milestone_at)
  end
end
