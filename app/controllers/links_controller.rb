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
    @recently_clicked = @all.sort { |a,b| b.last_clicked<=>(a.last_clicked) }[0,9]
    @recently_added = @all.sort { |a,b| b.created_at<=>(a.created_at) }[0,9]
    @most_often_1 = @all.sort { |a,b| b.clicks<=>a.clicks}[0,9]
    @most_often_2 = @all.sort { |a,b| b.clicks<=>a.clicks}[9,14]
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
        @link.update_attributes({'clicks' => @link.clicks += 1, 'last_clicked' => Time.now})
        redirect_to "http://#{@link.url}" 
      }
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
