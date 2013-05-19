# Copyright 2013 C. Benson Manica cbmanica(at)gmail.com
#
# This file is part of kobei.
#
# kobei is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'csv'

# Source data is
#
# http://earthquakes.usgs.gov/earthquakes/catalogs/eqs7day-M1.txt
#
# CSV headings:
# Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region
module EarthquakeImporter
  def self.import
    data=fetch_data
    self.parse_data response.body_str if data
  end

  private
  def self.fetch_data
    response=Curl::Easy.perform 'http://earthquakes.usgs.gov/earthquakes/catalogs/eqs7day-M1.txt' rescue nil
    return response.body_str if response.status == '200 OK'
    puts "Failed to fetch earthquakes data: #{response ? response.status : '<response was nil>'}"
    nil
  end

  def self.parse_data(data)
    return unless data
    insert_count=0
    update_count=0
    total=0
    CSV.parse data, :headers => true do |row|
      total+=1
      quake=Quake.where(:eid => row['Eqid']).first
      is_insert=false
      unless quake
        is_insert=true
        insert_count+=1
        quake=Quake.new # Does not persist the object yet
        quake.eid=row['Eqid']
      end
      quake.magnitude=row['Magnitude'].to_f
      quake.depth=row['Depth'].to_f
      quake.region=row['Region']
      quake.location=[row['Lon'].to_f, row['Lat'].to_f]
      quake.latitude=quake.location[1]
      quake.longitude=quake.location[0]
      quake.time=row['Datetime']
      if quake.changed?
        quake.save!
        update_count+=1 unless is_insert
      end
    end
    puts "Processed #{total} records - #{insert_count} inserted, #{update_count} updated"
  end
end