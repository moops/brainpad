class JournalsController < ApplicationController
  
  before_filter :authorize
  layout 'standard.html', :except => [:show, :edit]
  
  # GET /journals
  # GET /journals.xml
  def index
    @user = Person.find(session[:user_id])
    @journals = Journal.paginate :page => params[:page], :conditions => "person_id = #{session[:user_id]}", :order => 'entry_on desc', :per_page => 10

    @journal = Journal.new #for the 'new' form
    @journal.entry_on = Date.today.strftime("%b %d, %Y")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @journals }
    end
    
    
  end

  # GET /journals/1
  # GET /journals/1.xml
  def show
    @journal = Journal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @journal }
    end
  end

  # GET /journals/new
  # GET /journals/new.xml
  def new
    @journal = Journal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @journal }
    end
  end

  # GET /journals/1/edit
  def edit
    @journal = Journal.find(params[:id])
  end

  # POST /journals
  # POST /journals.xml
  def create
    @journal = Journal.new(params[:journal])
    
    respond_to do |format|
      if @journal.save
        flash[:notice] = 'Journal was successfully created.'
        format.html { redirect_to(journals_path) }
        format.xml  { render :xml => @journal, :status => :created, :location => @journal }
      else
        format.html { redirect_to(journals_path) }
        format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /journals/1
  # PUT /journals/1.xml
  def update
    logger.info('updating a journal')
    @journal = Journal.find(params[:id])

    respond_to do |format|
      if @journal.update_attributes(params[:journal])
        flash[:notice] = 'Journal was successfully updated.'
        format.html { redirect_to(journals_path) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(journals_path) }
        format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /journals/1
  # DELETE /journals/1.xml
  def destroy
    @journal = Journal.find(params[:id])
    @journal.destroy

    respond_to do |format|
      format.html { redirect_to(journals_url) }
      format.xml  { head :ok }
    end
  end
end
