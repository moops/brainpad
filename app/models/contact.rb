class Contact
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name
  field :email
  field :phone_home
  field :phone_work
  field :phone_cell
  field :address
  field :city
  field :tags
  field :comments

  belongs_to :person
  
  validates_presence_of :name
  
end
