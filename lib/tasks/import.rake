require 'import/earthquake_importer'

namespace :import do
  desc 'Import earthquakes information'
  task :earthquakes => :environment do
    EarthquakeImporter.import
  end
end