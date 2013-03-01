class Contact
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :nm, as: :name
  field :em, as: :email
  field :p_h, as: :phone_home
  field :p_w, as: :phone_work
  field :p_c, as: :phone_cell
  field :ad, as: :address
  field :ct, as: :city
  field :tg, as: :tags
  field :cm, as: :comments

  belongs_to :person

  validates_presence_of :name

  attr_accessible :person_id, :name, :email, :phone_home, :phone_work, :phone_cell, :address, :city, :tags, :comments

end
