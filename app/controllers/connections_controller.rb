class ConnectionsController < ApplicationController

  load_and_authorize_resource

  # GET /connections
  def index
    @connections = current_user.connections.asc(:name)
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
    p = connection_params.reject {|k, _v| k == 'person' }
    if @connection.update_attributes(p)
      current_user.tag('connection', @connection.tags)
      @connections = current_user.connections.asc(:name).page(params[:page])
      flash[:notice] = "connection #{@connection.name} was updated."
    end
  end

  # DELETE /connections/1
  def destroy
    @connection.destroy
    redirect_to(connections_path, format: 'html')
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def connection_params
    params.require(:connection).permit(:name, :username, :password, :url, :description, :tags)
  end
end
