class ContactsController < ApplicationController
  before_action :set_contact, only: %i[show edit update destroy]

  # GET /contacts
  def index
    authorize Contact
    @contacts = current_user.contacts.asc(:name)
    @contacts = @contacts.where(name: /#{params[:q]}/i) if params[:q]
    if params[:tag]
      @contacts = @contacts.where(tags: /#{params[:tag]}/)
      @tag = params[:tag]
    end
    @contacts = @contacts.page(params[:page])
  end

  # GET /contacts/1.js
  def show
    authorize @contact
  end

  # GET /contacts/1/new.js
  def new
    @contact = params[:contact_id] ? Contact.find(params[:contact_id]).dup : Contact.new
    authorize @contact
  end

  # GET /contacts/1/edit.js
  def edit
    authorize @contact
  end

  # POST /contacts.js
  def create
    authorize Contact
    @contact = current_user.contacts.build(contact_params)
    if @contact.save
      current_user.tag('contact', @contact.tags)
      @contacts = current_user.contacts.asc(:name).page(params[:page])
      flash[:notice] = "contact #{@contact.name} was created."
    end
  end

  # PUT /contacts/1.js
  def update
    authorize @contact
    if @contact.update_attributes(contact_params)
      current_user.tag('contact', @contact.tags)
      @contacts = current_user.contacts.asc(:name).page(params[:page])
      flash[:notice] = "contact #{@contact.name} was updated."
    end
  end

  # DELETE /contacts/1
  def destroy
    authorize @contact
    @contact.destroy
    redirect_to contacts_path
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(
      :name, :email, :phone_home, :phone_work, :phone_cell, :address, :city, :tags, :comments
    )
  end
end
