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
  field :cm, as: :comments
  field :tg, as: :tags

  belongs_to :person

  validates :name, presence: true
  paginates_per 15
end
