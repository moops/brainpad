class MilestonesController < ApplicationController

  before_filter :authenticate
  layout 'standard.html', :except => [:show]
  
  # GET /milestones
  # GET /milestones.xml
  def index    
    @milestones = get_milestones

    @milestone = Milestone.new #for the 'new' form

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @milestones }
    end
  end

  # GET /milestones/1
  # GET /milestones/1.xml
  def show
    @milestone = Milestone.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @milestone }
    end
  end

  # GET /milestones/new
  # GET /milestones/new.xml
  def new
    @milestone = Milestone.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @milestone }
    end
  end

  # GET /milestones/1/edit
  def edit
    @milestone = Milestone.find(params[:id])
    render(:partial => 'form')
  end

  # POST /milestones
  # POST /milestones.xml
  def create
    @milestone = Milestone.new(params[:milestone])
    logger.info("creating milestone: #{@milestone.inspect}")
    respond_to do |format|
      if @milestone.save
        flash[:notice] = 'Milestone was successfully created.'
        format.html { redirect_to(milestones_path) }
        format.xml  { render :xml => @milestone, :status => :created, :location => @milestone }
      else
        format.html { 
          @milestones = get_milestones
          render(:action => 'index') 
        }
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
        format.html { render :action => "edit" }
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
  
  private
  
  def get_milestones
    Milestone.paginate :page => params[:page], :conditions => "person_id = #{session[:user_id]}", :order => 'milestone_at', :per_page => 10
  end
   
end