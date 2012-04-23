class Journal
  include Mongoid::Document
  
  field :entry
  field :entry_on
  field :journal_type
  field :person_id, :type => Integer
  field :created_at, :type => DateTime
  field :updated_at, :type => DateTime

  belongs_to :person
  
  validates_presence_of :person, :entry, :entry_on
  
  def self.search(condition_params, page)
    condition_params[:q] = "%#{condition_params[:q]}%"
    logger.debug("Journal::search condition_params[#{condition_params.inspect}]")
    Journal.paginate :page => page, :conditions => get_search_conditions(condition_params), :order => 'entry_on desc', :per_page => 13
  end
  
  def self.get_search_conditions(condition_params)
    conditions = []
    query = 'journals.person_id = :user'
    query << ' and journals.entry like :q' unless condition_params[:q].blank?
    if !condition_params[:start_on].blank? && !condition_params[:end_on].blank?
      query << ' and journals.entry_on between :start_on and :end_on'
    elsif !condition_params[:start_on].blank?
      query << ' and journals.entry_on >= :start_on'
    elsif !condition_params[:end_on].blank?
      query << ' and journals.entry_on <= :end_on'
    end
    logger.debug("Journal::get_search_conditions query[#{query}]")
    conditions << query
    conditions << condition_params
  end
  
end
