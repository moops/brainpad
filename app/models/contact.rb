class Contact
  include Mongoid::Document
  
  field :name, type: String
  field :email, type: String
  field :phone_home, type: String
  field :phone_work, type: String
  field :phone_cell, type: String
  field :address, type: String
  field :city, type: String
  field :tags, type: String
  field :comments, type: String
  field :person_id, type: Integer
  field :created_at, type: DateTime
  field :updated_at, type: DateTime

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
    query << ' and contacts.name like :q' unless condition_params[:q].blank?
    logger.debug("Contact::get_search_conditions query[#{query}]")
    conditions << query
    conditions << condition_params
  end
  
end
