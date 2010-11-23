class ConnectionsController < ApplicationController
  
  before_filter :authorize
  layout 'standard', :except => :show
  
  # GET /connections
  # GET /connections.xml
  def index
    @connections = Connection.search({ :q => params[:q], :user => @user.id }, params[:page])
    @connection = Connection.new #for the 'new' form
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @connections }
    end
  end

  # GET /connections/1
  # GET /connections/1.xml
  def show
    @connection = Connection.find(params[:id])

    respond_to do |format|
      format.js { render :layout => false }
      format.xml  { render :xml => @connection }
    end
  end

  # GET /connections/new
  # GET /connections/new.xml
  def new
    @connection = Connection.new

    respond_to do |format|
      format.js { render :layout => false }
      format.xml  { render :xml => @connection }
    end
  end

  # GET /connections/1/edit
  def edit
    @connection = Connection.find(params[:id])
    respond_to do |format|
      format.html 
      format.js { render :layout => false }
    end
  end

  # POST /connections
  # POST /connections.xml
  def create
    @connection = Connection.new(params[:connection])

    respond_to do |format|
      if @connection.save
        flash[:notice] = 'Connection was successfully created.'
        format.html { redirect_to(connections_path) }
        format.xml  { render :xml => @connection, :status => :created, :location => @connection }
      else
        format.html { redirect_to(connections_path) }
        format.xml  { render :xml => @connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /connections/1
  # PUT /connections/1.xml
  def update
    @connection = Connection.find(params[:id])

    respond_to do |format|
      if @connection.update_attributes(params[:connection])
        flash[:notice] = 'Connection was successfully updated.'
        format.html { redirect_to(connections_path) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(connections_path) }
        format.xml  { render :xml => @connection.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /connections/1
  # DELETE /connections/1.xml
  def destroy
    @connection = Connection.find(params[:id])
    @connection.destroy

    respond_to do |format|
      format.html { redirect_to(connections_url) }
      format.xml  { head :ok }
    end
  end
end
