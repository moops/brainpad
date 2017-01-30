require 'feeds'

class LinksController < ApplicationController

  # GET /links
  def index
    authorize Link
    @links = current_user.links
    @recently_clicked = @links.desc(:last_clicked_on).limit(8)
    @recently_added = @links.desc(:created_at).limit(8)
    @most_often_1 = @links.desc(:clicks).limit(8)
    @random = @links.sort_by { rand }[0,8]
    @feeds = Feeds.get_feeds
    if params[:tag]
      @tagged_links = @links.where(tags: /#{params[:tag]}/)
      @tag = params[:tag]
    end
  end

  # GET /links/1
  def show
    @link = Link.find(params[:id])
    authorize @link
    @link.update_attributes(clicks: @link.clicks += 1, last_clicked_on: Time.now)
    redirect_to @link.url.include?("://") ? @link.url : "http://#{@link.url}"
  end

  # GET /links/new
  def new
    authorize Link
    @link = Link.where(url: params[:url]).first if params[:url]
    if @link
      flash[:notice] = "#{@link.url} already exists"
      redirect_to links_path and return
    end
    @link = Link.new unless @link
    @link.name = params[:name].downcase if params[:name]
    @link.url = params[:url]
  end

  # GET /links/1/edit
  def edit
    @link = Link.find(params[:id])
    authorize @link
  end

  # POST /links
  def create
    @link = current_user.links.build(link_params)
    authorize @link
    @link.person = current_user if current_user
    if @link.save
      current_user.tag('link', @link.tags)
      flash[:notice] = 'Link was successfully created.'
      redirect_to links_path
    else
      render action: 'new'
    end
  end

  # PUT /links/1
  def update
    @link = Link.find(params[:id])
    authorize @link
    if @link.update_attributes(link_params)
      current_user.tag('link', @link.tags)
      flash[:notice] = 'Link was successfully updated.'
      redirect_to links_path
    else
      render action: 'edit'
    end
  end

  # DELETE /links/1
  def destroy
    @link = Link.find(params[:id])
    authorize @link
    @link.destroy
    redirect_to links_path
  end

  # GET /links/find
  def find
    @found_links = Link.find(:all, conditions: "person_id = #{current_user.id} and tags like '%#{params[:tag]}%'")
    render partial: 'found_links'
  end

  # GET /links/clean
  def clean
    @links = current_user.links.asc(:name).page(params[:page])
  end

  # GET /link/refresh_tags
  def refresh_tags
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

  def link_params
    params.require(:link).permit(:name, :url, :tags, :comments, :expires_on, :clicks, :last_clicked_on)
  end
end