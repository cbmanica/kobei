ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end
  after :each do
    DatabaseCleaner.clean
  end
end

class ActionController::TestCase
  before :each do
    DatabaseCleaner.start
  end
  after :each do
    DatabaseCleaner.clean
  end
end