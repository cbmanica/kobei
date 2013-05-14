
class Quake
  include Mongoid::Document
  # Super handy but apparently a little out of date.  Generates some deprecation warnings.
  include Mongoid::Spacial::Document

  field :eid, type: String
  field :location, type: Array, spacial: true
  field :magnitude, type: Float
  field :depth, type: Float
  field :region, type: String
  field :time, type: DateTime

  index :eid => 1
  #spacial_index :location
end
