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
    @types = Lookup.where(category: 16).order_by(description: :asc)
    @priorities = Lookup.where(category: 11).order_by(code: :asc)
    @frequencies = Lookup.where(category: 36).order_by(code: :asc)
    if (params[:reminder_id])
      @reminder = Reminder.find(params[:reminder_id]).dup
    end
  end

  # GET /reminders/1/edit.js
  def edit
    @types = Lookup.where(category: 16).order_by(description: :asc)
    @priorities = Lookup.where(category: 11).order_by(code: :asc)
    @frequencies = Lookup.where(category: 36).order_by(code: :asc)
  end

  # POST /reminders
  def create
    @reminder = current_user.reminders.build(reminder_params)
    if @reminder.save
      current_user.tag('reminder', @reminder.tags)
      flash[:notice] = "reminder #{condense(@reminder.description)} was created."
      redirect_to reminders_path
    end
  end

  # PUT /reminders/1
  def update
    @reminder = current_user.reminders.find(params[:id])
    if @reminder.update_attributes(reminder_params)
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

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def reminder_params
    params.require(:reminder).permit(:description, :tags, :done, :repeat_until, :due_at, :reminder_type_id, :priority_id, :frequency)
  end
end
