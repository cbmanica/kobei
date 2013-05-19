class ExplictLatlong < Mongoid::Migration
  def self.up
    Quake.each do |quake|
      location=quake.location
      quake.latitude=location[1]
      quake.longitude=location[0]
      quake.save!
    end
  end

  def self.down
  end
end