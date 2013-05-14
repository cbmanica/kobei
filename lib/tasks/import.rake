require 'import/earthquake_importer'

namespace :import do
  desc 'Import earthquake information'
  task :earthquake => :environment do
    EarthquakeImporter.import
  end
end