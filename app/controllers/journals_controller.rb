class JournalsController < ApplicationController
  
  load_and_authorize_resource
  
  # GET /journals
  def index
    session[:journal_tags] = getUniqueTags
    
    @journals = current_user.journals.desc('entry_on')
    if params[:q]
      @journals = @journals.where(entry: /#{params[:q]}/i)
    end
    if params[:tag]
      @journals = @journals.where(tags: /#{params[:tag]}/)
      flash[:notice] = "showing only entries with: #{params[:tag]}."
      @tag = params[:tag]
    end
    @journals = @journals.page(params[:page])
  end

  # GET /journals/1.js
  def show
  end
  
  # GET /journals/1/new.js
  def new
    @types = Lookup.where(:category => 7).all
    if (params[:journal_id])
      @journal = Journal.find(params[:journal_id]).dup
    end
  end

  # GET /journals/1/edit.js
  def edit
    @types = Lookup.where(:category => 7).all
  end

  # POST /journals.js
  def create
    if @journal.save
      @journals = current_user.journals.desc(:entry_on).page(params[:page])
      flash[:notice] = "journal entry was created."
    end
  end

  # PUT /journals/1.js
  def update
    if @journal.update_attributes(params[:journal])
      @journals = current_user.journals.desc(:entry_on).page(params[:page])
      flash[:notice] = "journal entry was updated."
    end
  end

  # DELETE /journals/1
  def destroy
    @journal.destroy
    redirect_to(journals_path)
  end
  
  private

  def getUniqueTags
    unique_tags = []
    current_user.contacts.each do |contact|
      contact.tags.split.each do |tag|
        unique_tags.push(tag.strip)
      end
    end
    unique_tags.uniq.sort if unique_tags.uniq
  end
end