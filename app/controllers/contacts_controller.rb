class ContactsController < ApplicationController
  
  before_filter :authorize
  layout 'standard', :except => :show
  
  # GET /contacts
  # GET /contacts.xml
  def index
    session[:contact_tags] = getUniqueTags
    
    conditions = "person_id = #{@user.id}"
    if params[:tag]
      conditions = "tags like '%#{params[:tag]}%' and #{conditions}"
      @tag = params[:tag]
    end
    @contacts = Contact.paginate :page => params[:page], :conditions => conditions, :order => 'name', :per_page => 13
    @contact = Contact.new #for the 'new' form
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.js { render :layout => false }
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
    respond_to do |format|
      format.html 
      format.js { render :layout => false }
    end
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Contact was successfully created.'
        format.html { redirect_to(contacts_path) }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to(contacts_path) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(contacts_path) }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
    def getUniqueTags
      unique_tags = []
      all_contacts = Contact.find(:all, :conditions => "person_id = #{@user.id}")
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
