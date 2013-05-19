require 'erb'

MONGOID_CONFIG = YAML.load ERB.new(File.read(Rails.root.join('config/mongoid.yml'))).result