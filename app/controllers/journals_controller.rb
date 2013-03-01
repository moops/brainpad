class JournalsController < ApplicationController
  
  load_and_authorize_resource
  
  # GET /journals
  def index
    session[:journal_tags] = get_unique_tags
    
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

  def get_unique_tags
    unique_tags = []
    current_user.journals.each do |j|
      if j.tags
        j.tags.split.each do |tag|
          unique_tags.push(tag.strip)
        end
      end
    end
    unique_tags.uniq.sort unless unique_tags.empty?
  end
end