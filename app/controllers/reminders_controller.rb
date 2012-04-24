class RemindersController < ApplicationController

  load_and_authorize_resource
  layout 'standard.html', :except => :show

  # GET /reminders
  # GET /reminders.xml
  def index
    #@reminders = Reminder.search({ :q => params[:q], :user => @user.id, :start_on => params[:start_on], :end_on => params[:end_on] }, params[:page])
    @reminders = @user.reminders.order(:due_on)
    if params[:tag]
      @reminders = @reminders.where('tags like :tag', :tag => params[:tag])
      @tag = params[:tag]
    end
    @reminders = @reminders.page(params[:page]).per(13)
    
    @reminder = Reminder.new #for the 'new' form
    @reminder.due_on = Date.today.strftime("%b %d, %Y")
    
    @reminder_summary = ReminderSummary.new(@user,31)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reminders }
    end
  end

  # GET /reminders/1
  # GET /reminders/1.xml
  def show

    respond_to do |format|
      format.js { render :layout => false }
      format.xml  { render :xml => @reminder }
    end
  end

  # GET /reminders/new
  # GET /reminders/new.xml
  def new

    respond_to do |format|  
      format.html # new.html.erb
      format.xml  { render :xml => @reminder }
    end
  end

  # GET /reminders/1/edit
  def edit
    respond_to do |format|
      format.html 
      format.js { render :layout => false }
    end
  end

  # POST /reminders
  # POST /reminders.xml
  def create

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
    @reminder.destroy

    respond_to do |format|
      format.html { redirect_to(reminders_url) }
      format.xml  { head :ok }
    end
  end
  
  def finish
    params[:reminder].each { |reminder_id, attr|
      reminder = Reminder.find(reminder_id)
      reminder.update_attribute(:done,attr[:done])
    }
    redirect_to reminders_path
  end
 
end

class ReminderSummary

  attr_reader :created, :completed, :completion_rate, :on_time

  def initialize(user,days)
    reminders = Reminder.recent_reminders(user,days)
    @created = reminders.length
    @completed = 0
    @on_time = 0
    for r in reminders
      @completed += 1 if r.done
      @on_time += 1 if r.done and r.due_on > r.updated_at.to_date
    end
    @completion_rate = (@completed.to_f / @created.to_f) * 100
  end
    
end