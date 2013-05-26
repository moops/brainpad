class JournalsController < ApplicationController

  load_and_authorize_resource

  # GET /journals
  def index
    @journals = current_user.journals.desc('entry_on')
    if params[:q]
      @journals = @journals.where(entry: /#{params[:q]}/i)
    end
    if params[:tag]
      @journals = @journals.where(tags: /#{params[:tag]}/)
      @tag = params[:tag]
    end
    @journals = @journals.page(params[:page])
  end

  # GET /journals/1.js
  def show
  end

  # GET /journals/1/new.js
  def new
    @types = Lookup.where(category: 7).all
    if (params[:journal_id])
      @journal = Journal.find(params[:journal_id]).dup
    end
  end

  # GET /journals/1/edit.js
  def edit
    @types = Lookup.where(category: 7).all
  end

  # POST /journals.js
  def create
    @journal = current_user.journals.build(params[:journal])
    if @journal.save
      current_user.tag('journal', @journal.tags)
      @journals = current_user.journals.desc(:entry_on).page(params[:page])
      flash[:notice] = "journal entry was created."
    end
  end

  # PUT /journals/1.js
  def update
    @journal = current_user.journals.find(params[:id])
    #p = params[:journal].reject {|k, v| k == 'person' }
    #p[:journal_type] = Lookup.find(p[:journal_type])
    if @journal.update_attributes(params[:journal])
      current_user.tag('journal', @journal.tags)
      @journals = current_user.journals.desc(:entry_on).page(params[:page])
      flash[:notice] = "journal entry was updated."
    end
  end

  # DELETE /journals/1
  def destroy
    @journal.destroy
    redirect_to(journals_path)
  end
end