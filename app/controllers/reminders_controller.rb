class RemindersController < ApplicationController

  layout 'standard.html'

  # GET /reminders
  # GET /reminders.xml
  def index
    @user = Person.find(session[:user_id])
    @orderBy = params[:orderBy] ? params[:orderBy] : 'due'
    @reminders = Reminder.paginate :page => params[:page], :conditions => "done = 0 and person_id = #{session[:user_id]}", :order => @orderBy, :per_page => 10
    #@reminders = Reminder.find(:all,
    #                           :conditions => "done = 0 and person_id = #{session[:user_id]}", 
    #                           :order => @orderBy,
    #                           :page => {:size => 8, :current => params[:page]})
    @reminder = Reminder.new #for the 'new' form
    @reminder.due = Date.today.strftime("%b %d, %Y")
    @form_header = 'new item'
    @form_action = 'create'
    @form_btn_label = 'create'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reminders }
    end
  end

  # GET /reminders/1
  # GET /reminders/1.xml
  def show
    @reminder = Reminder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @reminder }
    end
  end

  # GET /reminders/new
  # GET /reminders/new.xml
  def new
    @reminder = Reminder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @reminder }
    end
  end

  # GET /reminders/1/edit
  def edit
    @reminder = Reminder.find(params[:id])
  end

  # POST /reminders
  # POST /reminders.xml
  def create
    @reminder = Reminder.new(params[:reminder])

    respond_to do |format|
      if @reminder.save
        flash[:notice] = 'Reminder was successfully created.'
        format.html { redirect_to(@reminder) }
        format.xml  { render :xml => @reminder, :status => :created, :location => @reminder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reminder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reminders/1
  # PUT /reminders/1.xml
  def update
    @reminder = Reminder.find(params[:id])

    respond_to do |format|
      if @reminder.update_attributes(params[:reminder])
        flash[:notice] = 'Reminder was successfully updated.'
        format.html { redirect_to(@reminder) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reminder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reminders/1
  # DELETE /reminders/1.xml
  def destroy
    @reminder = Reminder.find(params[:id])
    @reminder.destroy

    respond_to do |format|
      format.html { redirect_to(reminders_url) }
      format.xml  { head :ok }
    end
  end
end
