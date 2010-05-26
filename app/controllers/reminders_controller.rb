class RemindersController < ApplicationController

  before_filter :authenticate
  layout 'standard.html', :except => [:show]

  # GET /reminders
  # GET /reminders.xml
  def index
    @user = Person.find(session[:user_id])
    @order = params[:order] ? params[:order] : 'due'
    @reminders = Reminder.paginate :page => params[:page], :conditions => "(done = 0 or done = 'f') and person_id = #{session[:user_id]}", :order => @order, :per_page => 10

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
    render(:partial => 'form')
  end

  # POST /reminders
  # POST /reminders.xml
  def create
    @reminder = Reminder.new(params[:reminder])

    respond_to do |format|
      if @reminder.save
        flash[:notice] = 'Reminder was successfully created.'
        format.html { redirect_to(reminders_path) }
        format.xml  { render :xml => @reminder, :status => :created, :location => @reminder }
      else
        format.html { redirect_to(reminders_path) }
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
        format.html { redirect_to(reminders_path) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(reminders_path) }
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
  
  def finish
    logger.info "finishing: #{params[:reminder].inspect}"
    params[:reminder].each { |reminder_id, attr|
      reminder = Reminder.find(reminder_id)
      reminder.update_attribute(:done,attr[:done])
    }
    redirect_to reminders_path
  end
 
end
