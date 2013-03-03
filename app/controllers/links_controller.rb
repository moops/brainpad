require 'feeds'

class LinksController < ApplicationController

  load_and_authorize_resource
  
  # GET /links
  def index
    #unless session[:link_tags]
    #  session[:link_tags] = get_unique_tags
    #end
    links = current_user.links if current_user

    @recently_clicked = links.desc(:last_clicked_on).limit(8)
    @recently_added = links.desc(:created_at).limit(8)
    @most_often_1 = links.desc(:clicks).limit(8)
    @random = links.sort_by { rand }[0,8]
    @feeds = Feeds.get_feeds
  end

  # GET /links/1
  def show
    @link.update_attributes({clicks: @link.clicks += 1, 'last_clicked_on' => Time.now})
    redirect_to @link.url.include?("://") ? @link.url : "http://#{@link.url}"
  end

  # GET /links/new
  def new
    @link = Link.where(url: params[:url]).first if params[:url]
    if @link
      flash[:notice] = "#{@link.url} already exists"
      redirect_to links_path
    end
    @link = Link.new unless @link 
    @link.name = params[:name].downcase if params[:name]
    @link.url = params[:url]
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  def create
    @link.person = current_user if current_user
    if @link.save
      flash[:notice] = 'Link was successfully created.'
      redirect_to links_path
    else
      render action: 'new'
    end
  end

  # PUT /links/1
  def update
    if @link.update_attributes(params[:link])
      flash[:notice] = 'Link was successfully updated.'
      redirect_to @link
    else
      render action: 'edit'
    end
  end

  # DELETE /links/1
  def destroy
    @link.destroy
    redirect_to links_path
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
    @links = current_user.links.asc(:name).page(params[:page])
  end

  # GET /link/refresh_tags
  def refresh_tags
    session[:link_tags] = get_unique_tags
    render partial: 'tags'
  end

  # non-restfull inline editors
  def update_field
    link = Link.find(params[:id])
    link.update_attribute(params[:field], params[:value])
    render text: params[:value]
  end
  # end non-restfull inline editors

private

  def get_unique_tags
    unique_tags = []
    current_user.links.each do |link|
      if link.tags
        link.tags.split.each do |tag|
          unique_tags.push(tag.strip)
        end
      end
    end
    unique_tags.uniq.sort unless unique_tags.empty?
  end
end