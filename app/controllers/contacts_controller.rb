class ContactsController < ApplicationController

  load_and_authorize_resource

  # GET /contacts
  def index
    @contacts = current_user.contacts.asc(:name)
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
    @contact = current_user.contacts.build(params[:contact])
    if @contact.save
      current_user.tag('contact', @contact.tags)
      @contacts = current_user.contacts.asc(:name).page(params[:page])
      flash[:notice] = "contact #{@contact.name} was created."
    end
  end

  # PUT /contacts/1.js
  def update
    @contact = current_user.contacts.find(params[:id])
    if @contact.update_attributes(params[:contact])
      current_user.tag('contact', @contact.tags)
      @contacts = current_user.contacts.asc(:name).page(params[:page])
      flash[:notice] = "contact #{@contact.name} was updated."
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
    redirect_to contacts_path
  end
end
