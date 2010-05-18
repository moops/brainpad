require 'feeds'

class LinksController < ApplicationController

  before_filter :authenticate
  layout 'standard.html'
  
  # GET /links
  # GET /links.xml
  def index
    unless session[:tags]
      session[:tags] = getUniqueTags
    end
    @all = Link.find(:all, :conditions => "person_id = #{session[:user_id]}")
    
    @recently_clicked = @all.sort { |a,b| (a.last_clicked and b.last_clicked) ? b.last_clicked<=>(a.last_clicked) : 0 }[0,9]
    @recently_added = @all.sort { |a,b| b.created_at<=>(a.created_at) }[0,9]
    @most_often_1 = @all.sort { |a,b| (b.clicks and a.clicks) ? b.clicks<=>a.clicks : 0 }[0,9]
    @most_often_2 = @all.sort { |a,b| (b.clicks and a.clicks) ? b.clicks<=>a.clicks : 0 }[9,9]
    @random = @all.sort_by { rand }[0,9]
    @milestone = Milestone.find(:first, :conditions => "person_id = #{session[:user_id]}")
    @due_today = Reminder.todays(@user.id)
    @feeds = Feeds.get_feeds
    
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
      format.html { 
        clicks = @link.clicks ? @link.clicks += 1 : 1
        @link.update_attributes({'clicks' => clicks, 'last_clicked' => Time.now})
        redirect_to "http://#{@link.url}" 
      }
      format.xml  { render :xml => @link }
    end
  end

  # GET /links/new
  # GET /links/new.xml
  def new
    @link = Link.find_by_url(params[:url].sub('http://',''))
    if @link
      flash[:notice] = "#{@link.url} already exists"
      redirect_to(links_path)
    end
    @link = Link.new unless @link 
    @link.name = params[:name].downcase
    @link.url = params[:url]
    @link.url.sub!('http://','')

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
    logger.info('create called')
    @link = Link.new(params[:link])
    @link.person = @user
    logger.info('@link: ' + @link.inspect)
    
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
  
  # GET /links/find
  # GET /links/find.xml
  def find
    @found_links = Link.find(:all, :conditions => "person_id = #{session[:user_id]} and tags like '%#{params[:tag]}%'")

    respond_to do |format|
      format.html { render :partial => 'found_links' }
      format.xml  { render :xml => @found_links }
    end
  end
  
  # GET /links/clean
  def clean
    @links = Link.paginate :page => params[:page], :conditions => "person_id = #{session[:user_id]}", :order => :name, :per_page => 15
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
