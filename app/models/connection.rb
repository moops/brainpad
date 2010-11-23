class Connection < ActiveRecord::Base

  belongs_to :person
  
  validates_presence_of :person, :username, :password, :url
  
  def self.search(condition_params, page)
    condition_params[:q] = "%#{condition_params[:q]}%"
    logger.debug("Connection::search condition_params[#{condition_params.inspect}]")
    Connection.paginate :page => page, :conditions => get_search_conditions(condition_params), :order => 'name', :per_page => 13
  end
  
  def self.get_search_conditions(condition_params)
    conditions = []
    query = 'connections.person_id = :user'
    if !condition_params[:q].blank?
      query << ' and connections.name like :q' if condition_params[:q]
    end
    logger.debug("Connection::get_search_conditions query[#{query}]")
    conditions << query
    conditions << condition_params
  end
  
end
