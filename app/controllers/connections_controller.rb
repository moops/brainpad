class ConnectionsController < ApplicationController
  
  load_and_authorize_resource
  
  # GET /connections
  def index
    session[:connection_tags] = getUniqueTags
    
    @connections = current_user.connections.asc(:name)
    if params[:q]
      @connections = @connections.where(name: /#{params[:q]}/i)
    end
    if params[:tag]
      @connections = @connections.where(tags: /#{params[:tag]}/)
      flash[:notice] = "showing only #{params[:tag]} connections."
      @tag = params[:tag]
    end
    @connections = @connections.page(params[:page])
  end

  # GET /connections/1.js
  def show
  end

  # GET /connections/new.js
  def new
    if (params[:connection_id])
      @connection = Connection.find(params[:connection_id]).dup
    end
  end

  # GET /connections/1/edit.js
  def edit
  end

  # POST /connections.js
  def create
    if @connection.save
      @connections = current_user.connections.asc(:name).page(params[:page])
      flash[:notice] = "connection #{@connection.name} was created."
    end
  end

  # PUT /connections/1.js
  def update
    if @connection.update_attributes(params[:connection])
      @connections = current_user.connections.asc(:name).page(params[:page])
      flash[:notice] = "connection #{@connection.name} was updated."
    end
  end

  # DELETE /connections/1
  def destroy
    @connection.destroy
    redirect_to connections_url
  end
  
  private
  
  def getUniqueTags
    unique_tags = []
    current_user.contacts.each do |contact|
      contact.tags.split.each do |tag|
        unique_tags.push(tag.strip)
      end
    end
    unique_tags.uniq!
    unique_tags.sort!
  end
end
