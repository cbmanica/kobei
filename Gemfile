source 'https://rubygems.org'

# Necessary to get Heroku to run the right Ruby version for Mongoid
ruby '1.9.3'
gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem "mongoid", "~> 3.0.0"
gem 'mongoid_rails_migrations'
gem 'bson_ext'
gem 'mongo'

gem 'curb'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# Use unicorn as the app server
gem 'unicorn'
gem 'unicorn-rails'

gem 'minitest-rails'

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end
