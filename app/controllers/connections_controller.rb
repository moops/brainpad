class ConnectionsController < ApplicationController

  # GET /connections
  def index
    authorize Connection
    @connections = policy_scope(Connection).asc(:name)
    if params[:q]
      @connections = @connections.where(name: /#{params[:q]}/i)
    end
    if params[:tag]
      @connections = @connections.where(tags: /#{params[:tag]}/)
      @tag = params[:tag]
    end
    @connections = @connections.page(params[:page])
  end

  # GET /connections/1.js
  def show
    @connection = Connection.find(params[:id])
    authorize @connection
  end

  # GET /connections/new.js
  def new
    @connection = (params[:connection_id]) ? Connection.find(params[:connection_id]).dup : Connection.new
    authorize @connection
  end

  # GET /connections/1/edit.js
  def edit
    @connection = Connection.find(params[:id])
    authorize @connection
  end

  # POST /connections.js
  def create
    authorize Connection
    @connection = current_user.connections.build(connection_params)
    if @connection.save
      current_user.tag('connection', @connection.tags)
      @connections = current_user.connections.asc(:name).page(params[:page])
      flash[:notice] = "connection #{@connection.name} was created."
    end
  end

  # PUT /connections/1.js
  def update
    @connection = current_user.connections.find(params[:id])
    authorize @connection
    p = connection_params.reject {|k, _v| k == 'person' }
    if @connection.update_attributes(p)
      current_user.tag('connection', @connection.tags)
      @connections = current_user.connections.asc(:name).page(params[:page])
      flash[:notice] = "connection #{@connection.name} was updated."
    end
  end

  # DELETE /connections/1
  def destroy
    @connection = Connection.find(params[:id])
    authorize @connection
    @connection.destroy
    redirect_to(connections_path, format: 'html')
  end

  private

  def connection_params
    params.require(:connection).permit(:name, :username, :password, :url, :description, :tags)
  end
end
