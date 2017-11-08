class Link
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :url
  field :nm, as: :name
  field :tg, as: :tags
  field :cm, as: :comments
  field :cl, as: :clicks, type: Integer, default: 0
  field :l_on, as: :last_clicked_on, type: Date
  field :e_on, as: :expires_on, type: Date

  belongs_to :person

  validates :url, presence: true
  validates :name, presence: true

  def description
    name + (comments ? " - #{comments}" : '')
  end
end
