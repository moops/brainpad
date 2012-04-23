class Contact
  include Mongoid::Document
  
  field :name
  field :email
  field :phone_home
  field :phone_work
  field :phone_cell
  field :address
  field :city
  field :tags
  field :comments
  field :person_id, :type => Integer
  field :created_at, :type => DateTime
  field :updated_at, :type => DateTime

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
