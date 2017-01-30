class JournalsController < ApplicationController

  # GET /journals
  def index
    authorize Journal
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
    @journal = Journal.find(params[:id])
    authorize @journal
  end

  # GET /journals/1/new.js
  def new
    @journal = (params[:journal_id]) ? Journal.find(params[:journal_id]).dup : Journal.new
    authorize @journal
    @types = Lookup.where(category: 7).order_by(description: :asc)
  end

  # GET /journals/1/edit.js
  def edit
    @journal = Journal.find(params[:id])
    authorize @journal
    @types = Lookup.where(category: 7).order_by(description: :asc)
  end

  # POST /journals.js
  def create
    authorize Journal
    @journal = current_user.journals.build(journal_params)
    if @journal.save
      current_user.tag('journal', @journal.tags)
      @journals = current_user.journals.desc(:entry_on).page(params[:page])
      flash[:notice] = "journal entry was created."
    end
  end

  # PUT /journals/1.js
  def update
    @journal = Journal.find(params[:id])
    authorize @journal
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
    @journal = Journal.find(params[:id])
    authorize @journal
    @journal.destroy
    redirect_to(journals_path)
  end

  private

  def journal_params
    params.require(:journal).permit(:entry, :tags, :entry_on, :journal_type_id)
  end
end
