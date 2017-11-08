class Connection
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :nm, as: :name
  field :un, as: :username
  field :pw, as: :password
  field :url
  field :dsc, as: :description
  field :tg, as: :tags

  belongs_to :person

  validates :username, presence: true
  validates :password, presence: true
  validates :url, presence: true
  paginates_per 15
end
