# require 'feeds'

class LinksController < ApplicationController

  load_and_authorize_resource
  
  # GET /links
  # GET /links.xml
  def index
    #@current_user = Person.first
    unless session[:tags]
      session[:tags] = getUniqueTags
    end

    links = Link.all
    links = @current_user.links if @current_user

    @recently_clicked = links.desc(:last_clicked_on).limit(4).all
    @recently_added = links.desc(:created_at).limit(4).all
    @most_often_1 = links.desc(:clicks).limit(4).all
    @random = links.sort_by { rand }[0,4]
    
    @milestone = Milestone.next_milestone(current_user)
    @due_today = Reminder.todays(current_user)
    # @feeds = Feeds.get_feeds

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @links }
    end
  end

  # GET /links/1
  # GET /links/1.xml
  def show
    respond_to do |format|
      format.html { 
        clicks = @link.clicks ? @link.clicks += 1 : 1
        @link.update_attributes({'clicks' => clicks, 'last_clicked_on' => Time.now})
        redirect_to @link.url
      }
      format.xml  { render :xml => @link }
    end
  end

  # GET /links/new
  # GET /links/new.xml
  def new
    @link = Link.where(url: params[:url]).first if params[:url]
    if @link
      flash[:notice] = "#{@link.url} already exists"
      redirect_to(links_path)
    end
    @link = Link.new unless @link 
    @link.name = params[:name].downcase if params[:name]
    @link.url = params[:url]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.xml
  def create
    @link.person = current_user if current_user
    respond_to do |format|
      if @link.save
        flash[:notice] = 'Link was successfully created.'
        format.html { redirect_to(links_path) }
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
    @link.destroy

    respond_to do |format|
      format.html { redirect_to(links_url) }
      format.xml  { head :ok }
    end
  end

  # GET /links/find
  # GET /links/find.xml
  def find
    logger.info('finding links...')
    @found_links = Link.find(:all, :conditions => "person_id = #{current_user.id} and tags like '%#{params[:tag]}%'")
    logger.info("found links: #{@found_links.inspect}")
    respond_to do |format|
      format.html { render :partial => 'found_links' }
      format.xml  { render :xml => @found_links }
    end
  end

  # GET /links/clean
  def clean
    @links = Link.paginate :page => params[:page], :conditions => "person_id = #{@current_user.id}", :order => :name, :per_page => 15
  end

  # GET /link/refresh_tags
  def refresh_tags
    session[:tags] = getUniqueTags
    render(:partial => 'tags')
  end

  # non-restfull inline editors
  def update_field
    link = Link.find(params[:id])
    link.update_attribute(params[:field], params[:value])
    render(:text => params[:value])
  end
  # end non-restfull inline editors

private

  def getUniqueTags
    unique_tags = []
    all_links = Link.all
    #all_links = Link.find_by_sql("select * from links where person_id = #{@user.id}")
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