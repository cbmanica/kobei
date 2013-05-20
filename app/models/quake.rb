class Quake
  include Mongoid::Document
  EARTH_RADIUS_MILES=3959
  EARTH_RADIUS_KM=6371

  field :location, :type => Array

  field :latitude, :type => Float
  field :longitude, :type => Float
  field :eid, type: String
  field :magnitude, type: Float
  field :depth, type: Float
  field :region, type: String
  field :time, type: DateTime

  index :eid => 1
  index :magnitude => 1
  index :time => 1

  index({loc: Mongo::GEO2D}, {background: true})

  def self.near_geo(lat, long, radius, units=:mi)
    case units
      when :mi
        earth_radius=EARTH_RADIUS_MILES
      when :km
        earth_radius=EARTH_RADIUS_KM
      else
        earth_radius=EARTH_RADIUS_MILES
    end
    Quake.where(:location => {"$within" => {"$centerSphere" => [[long,lat], radius.fdiv(earth_radius)]}})
  end
end
