class ContactsController < ApplicationController
  
  before_filter :authenticate
  layout 'standard', :except => :show
  
  # GET /contacts
  # GET /contacts.xml
  def index
    @user = Person.find(session[:user_id])
    @order = params[:order] ? params[:order] : 'name'
    
    unless session[:contact_tags]
          logger.info "session tag list is empty"
          session[:contact_tags] = getUniqueTags
    end
    
    conditions = "person_id = #{session[:user_id]}"
    if params[:tag]
      conditions = "tags like '%#{params[:tag]}%' and person_id = #{session[:user_id]}"
      @tag = params[:tag]
    end
    @contacts = Contact.paginate :page => params[:page], :conditions => conditions, :order => @order, :per_page => 10

    @contact = Contact.new #for the 'new' form
    @form_header = 'new contact'
    @form_action = 'create'
    @form_btn_label = 'create'
    
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
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
    render(:partial => 'form')
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
        format.html { redirect_to(@contact) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
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
      all_contacts = Contact.find_by_sql("select * from contacts where person_id = #{session[:user_id]}")
      all_contacts.each { |cur_contact|
        cur_contact.tags.split(seperator = ' ') { |cur_tag|
          unique_tags.push(cur_tag.strip)
        }
      }
      unique_tags.uniq!
      unique_tags.sort!
      return unique_tags
    end
    
end
