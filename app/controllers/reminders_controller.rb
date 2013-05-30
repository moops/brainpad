class RemindersController < ApplicationController

  load_and_authorize_resource

  # GET /reminders
  def index
    @reminders = current_user.reminders.outstanding.asc(:due_at)
    if params[:tag]
      @reminders = @reminders.where(tags: /#{params[:tag]}/)
      @tag = params[:tag]
    end
    if params[:q]
      @reminders = @reminders.where(description: /#{params[:q]}/i)
    end
    @reminders = @reminders.page(params[:page])
    @reminder_summary = Reminder.summary(current_user,31)
  end

  # GET /reminders/1.js
  def show
  end

  # GET /reminders/new.js
  def new
    @types = Lookup.where(category: 16).all
    @priorities = Lookup.where(category: 11).all
    @frequencies = Lookup.where(category: 36).all
    if (params[:reminder_id])
      @reminder = Reminder.find(params[:reminder_id]).dup
    end
  end

  # GET /reminders/1/edit.js
  def edit
    @types = Lookup.where(category: 16).all
    @priorities = Lookup.where(category: 11).all
    @frequencies = Lookup.where(category: 36).all
  end

  # POST /reminders
  def create
    @reminder = current_user.reminders.build(params[:reminder])
    if @reminder.save
      current_user.tag('reminder', @reminder.tags)
      flash[:notice] = "reminder #{condense(@reminder.description)} was created."
      redirect_to reminders_path
    end
  end

  # PUT /reminders/1
  def update
    @reminder = current_user.reminders.find(params[:id])
    if @reminder.update_attributes(params[:reminder])
      current_user.tag('reminder', @reminder.tags)
      flash[:notice] = "reminder #{condense(@reminder.description)} was updated."
      redirect_to reminders_path
    end
  end

  # DELETE /reminders/1
  def destroy
    @reminder.destroy
    redirect_to reminders_url
  end

  # POST /reminders/finish
  def finish
    params[:reminder].each { |reminder_id, attr|
      reminder = Reminder.find(reminder_id)
      reminder.update_attribute(:done,attr[:done])
    }
    redirect_to reminders_path
  end
end