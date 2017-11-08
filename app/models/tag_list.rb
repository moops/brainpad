class TagList
  include Mongoid::Document

  field :tags
  field :type

  embedded_in :person
end
