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
    @types = Lookup.where(category: 7).order_by(description: :asc)
    if (params[:journal_id])
      @journal = Journal.find(params[:journal_id]).dup
    end
  end

  # GET /journals/1/edit.js
  def edit
    @types = Lookup.where(category: 7).order_by(description: :asc)
  end

  # POST /journals.js
  def create
    @journal = current_user.journals.build(journal_params)
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
    if @journal.update_attributes(journal_params)
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

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def journal_params
    params.require(:journal).permit(:entry, :tags, :entry_on, :journal_type_id)
  end
end
