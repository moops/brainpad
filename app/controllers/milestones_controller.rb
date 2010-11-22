class MilestonesController < ApplicationController

  before_filter :authorize
  layout 'standard.html', :except => :show
  
  # GET /milestones
  # GET /milestones.xml
  def index    
    @milestones = Milestone.paginate :page => params[:page], :conditions => "person_id = #{@user.id}", :order => 'milestone_at', :per_page => 12

    @milestone = Milestone.new #for the 'new' form

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @milestones }
    end
  end

  # GET /milestones/1/edit
  def edit
    @milestone = Milestone.find(params[:id])
    respond_to do |format|
      format.html 
      format.js { render :layout => false }
    end
  end
  
  # GET /milestones/1
  # GET /milestones/1.xml
  def show
    @milestone = Milestone.find(params[:id])

    respond_to do |format|
      format.js { render :layout => false }
      format.xml  { render :xml => @milestone }
    end
  end

  # POST /milestones
  # POST /milestones.xml
  def create
    @milestone = Milestone.new(params[:milestone])
    respond_to do |format|
      if @milestone.save
        flash[:notice] = 'Milestone was successfully created.'
        format.html { redirect_to(milestones_path) }
        format.xml  { render :xml => @milestone, :status => :created, :location => @milestone }
      else
        format.html { redirect_to(milestones_path) }
        format.xml  { render :xml => @milestone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /milestones/1
  # PUT /milestones/1.xml
  def update
    @milestone = Milestone.find(params[:id])

    respond_to do |format|
      if @milestone.update_attributes(params[:milestone])
        flash[:notice] = 'Milestone was successfully updated.'
        format.html { redirect_to(milestones_path) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(milestones_path) }
        format.xml  { render :xml => @milestone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /milestones/1
  # DELETE /milestones/1.xml
  def destroy
    @milestone = Milestone.find(params[:id])
    @milestone.destroy

    respond_to do |format|
      format.html { redirect_to(milestones_url) }
      format.xml  { head :ok }
    end
  end
   
end
