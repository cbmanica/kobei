class Quake
  include Mongoid::Document

  field :location, :type => Array

  field :latitude, :type => Float
  field :longitude, :type => Float
  field :eid, type: String
  field :magnitude, type: Float
  field :depth, type: Float
  field :region, type: String
  field :time, type: DateTime

  index :eid => 1

  index({loc: Mongo::GEO2D}, {background: true})
end
