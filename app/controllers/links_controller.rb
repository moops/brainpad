class LinksController < ApplicationController

  before_filter :authenticate
  layout 'standard.html'
  
  # GET /links
  # GET /links.xml
  def index
    @user = Person.find(session[:user_id])
    unless session[:tags]
      logger.info "session tag list is empty"
      session[:tags] = getUniqueTags
    end
    logger.info "index() user: #{@user.inspect}"
    @recently_clicked = Link.find(:all, :limit => 18, :conditions => "person_id = #{session[:user_id]}", :order => 'last_clicked desc')
    @recently_added = Link.find(:all, :limit => 8, :conditions => "person_id = #{session[:user_id]}", :order => 'created_at desc')
    @most_often = Link.find(:all, :limit => 18, :conditions => "person_id = #{session[:user_id]}", :order => 'clicks desc')
    @random = Link.find(:all, :limit => 8, :conditions => "person_id = #{session[:user_id]}", :order => 'rand()')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @links }
    end
  end

  # GET /links/1
  # GET /links/1.xml
  def show
    @link = Link.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # GET /links/new
  # GET /links/new.xml
  def new
    @link = Link.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # GET /links/1/edit
  def edit
    @link = Link.find(params[:id])
  end

  # POST /links
  # POST /links.xml
  def create
    @link = Link.new(params[:link])

    respond_to do |format|
      if @link.save
        flash[:notice] = 'Link was successfully created.'
        format.html { redirect_to(@link) }
        format.xml  { render :xml => @link, :status => :created, :location => @link }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /links/1
  # PUT /links/1.xml
  def update
    @link = Link.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(params[:link])
        flash[:notice] = 'Link was successfully updated.'
        format.html { redirect_to(@link) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.xml
  def destroy
    @link = Link.find(params[:id])
    @link.destroy

    respond_to do |format|
      format.html { redirect_to(links_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
    def getUniqueTags
      unique_tags = []
      #all_links = Link.find(:all)
      all_links = Link.find_by_sql("select * from links where person_id = #{session[:user_id]}")
      all_links.each { |cur_link|
        if cur_link.tags
          cur_link.tags.split(' ').each { |cur_tag|
            unique_tags.push(cur_tag.strip)
          }
        end
      }
      unique_tags.uniq!
      unique_tags.sort!
      return unique_tags
    end
end
