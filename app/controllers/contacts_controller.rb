class ContactsController < ApplicationController
  
  load_and_authorize_resource
  
  # GET /contacts
  # GET /contacts.xml
  def index
    session[:contact_tags] = getUniqueTags
    
    @contacts = @current_user.contacts.asc(:name)
    if params[:tag]
      @contacts = @contacts.where(tags: /#{params[:tag]}/)
      @tag = params[:tag]
    end
    @contacts = @contacts.page(params[:page]).per(13)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    respond_to do |format|
      format.js { render :layout => false }
      format.xml  { render :xml => @contact }
    end
  end
  
  # GET /contacts/1/new
  def new
  end

  # GET /contacts/1/edit
  def edit
    respond_to do |format|
      format.html 
      format.js
    end
  end

  # POST /contacts.js
  def create
    respond_to do |format|
      if @contact.save
        @contacts = @current_user.contacts.asc(:name).page(params[:page]).per(13)
        flash[:notice] = 'Contact was successfully created.'
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
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to(contacts_path) }
      else
        format.html { redirect_to(contacts_path) }
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
    all_contacts.each { |cur_contact|
      cur_contact.tags.split.each { |cur_tag|
        unique_tags.push(cur_tag.strip)
      }
    }
    unique_tags.uniq!
    unique_tags.sort!
    return unique_tags
  end
end
