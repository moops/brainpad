class JournalsController < ApplicationController
  
  load_and_authorize_resource
  layout 'standard.html', :except => :show
  
  # GET /journals
  # GET /journals.xml
  def index
    #@journals = Journal.search({ :q => params[:q], :user => @user.id, :start_on => params[:start_on], :end_on => params[:end_on] }, params[:page])

    @journals = @user.journals.order('entry_on desc')
    if params[:tag]
      @journals = @journals.where('tags like :tag', :tag => params[:tag])
      @tag = params[:tag]
    end
    @journals = @journals.page(params[:page]).per(13)
    
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
    respond_to do |format|
      format.js { render :layout => false }
      format.xml { render :xml => @journal }
    end
  end

  # GET /journals/1/edit
  def edit
    @journal = Journal.find(params[:id])
    respond_to do |format|
      format.html 
      format.js { render :layout => false }
    end
  end

  # POST /journals
  # POST /journals.xml
  def create
    respond_to do |format|
      if @journal.save
        flash[:notice] = 'Journal was successfully created.'
        format.html { redirect_to(journals_path) }
        format.xml  { render :xml => @journal, :status => :created, :location => @journal }
      else
        flash[:notice] = 'Journal save failed.'
        format.html { redirect_to(journals_path) }
        format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /journals/1
  # PUT /journals/1.xml
  def update
    respond_to do |format|
      if @journal.update_attributes(params[:journal])
        flash[:notice] = 'Journal was successfully updated.'
        format.html { redirect_to(journals_path) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Journal update failed.'
        format.html { redirect_to(journals_path) }
        format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /journals/1
  # DELETE /journals/1.xml
  def destroy
    @journal.destroy

    respond_to do |format|
      format.html { redirect_to(journals_url) }
      format.xml  { head :ok }
    end
  end

end
