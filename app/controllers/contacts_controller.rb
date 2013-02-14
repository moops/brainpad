class ContactsController < ApplicationController
  
  load_and_authorize_resource
  
  # GET /contacts
  # GET /contacts.xml
  def index
    session[:contact_tags] = getUniqueTags
    
    @contacts = @current_user.contacts.asc(:name)
    if params[:q]
      @contacts = @contacts.where(name: /#{params[:q]}/i)
    end
    if params[:tag]
      @contacts = @contacts.where(tags: /#{params[:tag]}/)
      flash[:notice] = "showing only #{params[:tag]} contacts."
      @tag = params[:tag]
    end
    @contacts = @contacts.page(params[:page])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  # GET /contacts/1
  def show
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
  # GET /contacts/1/new
  def new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts.js
  def create
    respond_to do |format|
      if @contact.save
        @contacts = @current_user.contacts.asc(:name).page(params[:page])
        flash[:notice] = "contact #{@contact.name} was created."
        format.js
      else
        format.js 
      end
    end
  end

  # PUT /contacts/1
  def update
    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        @contacts = @current_user.contacts.asc(:name).page(params[:page])
        flash[:notice] = 'contact #{@contact.name} was updated.'
        format.js
      else
        format.js
      end
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to(contacts_url) }
    end
  end

private

  def getUniqueTags
    unique_tags = []
    all_contacts = @current_user.contacts
    all_contacts.each do |contact|
      contact.tags.split.each do |tag|
        unique_tags.push(tag.strip)
      end
    end
    unique_tags.uniq!
    unique_tags.sort!
  end
end
