class Contact < ActiveRecord::Base

  belongs_to :person
  
  validates_presence_of :person, :name
  
  def self.search(condition_params, page)
    condition_params[:q] = "%#{condition_params[:q]}%"
    logger.debug("Contact::search condition_params[#{condition_params.inspect}]")
    Contact.paginate :page => page, :conditions => get_search_conditions(condition_params), :order => 'name', :per_page => 13
  end
  
  def self.get_search_conditions(condition_params)
    conditions = []
    query = 'contacts.person_id = :user'
    if !condition_params[:q].blank?
      query << ' and contacts.name like :q' if condition_params[:q]
    end
    logger.debug("Contact::get_search_conditions query[#{query}]")
    conditions << query
    conditions << condition_params
  end
  
end
