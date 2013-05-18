
class Quake
  include Mongoid::Document
  include Mongoid::Geospatial

  field :eid, type: String
  geo_field :location
  field :magnitude, type: Float
  field :depth, type: Float
  field :region, type: String
  field :time, type: DateTime

  index :eid => 1
  spatial_index :location
end
