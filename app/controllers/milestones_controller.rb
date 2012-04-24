class MilestonesController < ApplicationController

  load_and_authorize_resource
  layout 'standard.html', :except => :show
  
  # GET /milestones
  # GET /milestones.xml
  def index    
    #@milestones = Milestone.paginate :page => params[:page], :conditions => "person_id = #{@user.id}", :order => 'milestone_at', :per_page => 13

    @milestones = @user.milestones.order(:milestone_at)
    if params[:tag]
      @milestones = @milestones.where('tags like :tag', :tag => params[:tag])
      @tag = params[:tag]
    end
    @milestones = @milestones.page(params[:page]).per(13)
    
    @milestone = Milestone.new #for the 'new' form

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @milestones }
    end
  end

  # GET /milestones/1/edit
  def edit
    respond_to do |format|
      format.html 
      format.js { render :layout => false }
    end
  end

  # GET /milestones/1
  # GET /milestones/1.xml
  def show
    respond_to do |format|
      format.js { render :layout => false }
      format.xml  { render :xml => @milestone }
    end
  end

  # POST /milestones
  # POST /milestones.xml
  def create
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
    @milestone.destroy

    respond_to do |format|
      format.html { redirect_to(milestones_url) }
      format.xml  { head :ok }
    end
  end
  
end
