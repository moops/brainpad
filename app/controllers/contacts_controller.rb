class ContactsController < ApplicationController
  
  load_and_authorize_resource
  
  # GET /contacts
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
  end

  # GET /contacts/1.js
  def show
  end
  
  # GET /contacts/1/new.js
  def new
    if (params[:contact_id])
      @contact = Contact.find(params[:contact_id]).dup
    end
  end

  # GET /contacts/1/edit.js
  def edit
  end

  # POST /contacts.js
  def create
    if @contact.save
      @contacts = current_user.contacts.asc(:name).page(params[:page])
      flash[:notice] = "contact #{@contact.name} was created."
    end
  end

  # PUT /contacts/1.js
  def update
    if @contact.update_attributes(params[:contact])
      @contacts = @current_user.contacts.asc(:name).page(params[:page])
      flash[:notice] = "contact #{@contact.name} was updated."
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
    redirect_to contacts_path
  end

  private

  def getUniqueTags
    unique_tags = []
    current_user.contacts.each do |contact|
      contact.tags.split.each do |tag|
        unique_tags.push(tag.strip)
      end
    end
    unique_tags.uniq!
    unique_tags.sort!
  end
end
