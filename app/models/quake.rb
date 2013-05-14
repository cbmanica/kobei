
class Quake
  include Mongoid::Document
  include Mongoid::Spacial::Document

  field :eid, type: String
  field :location, type: Array, spacial: true
  field :magnitude, type: Float
  field :depth, type: Float
  field :region, type: String

  index :eid => 1
end
