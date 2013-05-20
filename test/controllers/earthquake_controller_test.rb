require_relative '../test_helper'
require File.join Rails.root, 'app/controllers/earthquakes_controller'

class EarthquakeControllerTest < ActionController::TestCase
  describe EarthquakesController do
    FLOAT_TOLERANCE=0.00001

  before do
      FactoryGirl.create :quake1
      FactoryGirl.create :quake2
    end

    it 'must require json format' do
      get :index
      assert_response :not_acceptable
    end

    it 'must return all quakes' do
      get :index, :format => 'json'
      assert_response :success
      json=JSON.parse response.body
      assert_equal 2, json.count
    end

    it 'must filter by magnitude' do
      get :index, :format => 'json', :over => 4
      assert_response :success
      json=JSON.parse response.body
      assert_equal 1, json.count
      assert_equal '16', json[0]['eid']
    end

    it 'must allow changing the sort order' do
      get :index, :format => 'json', :order => 'magnitude'
      assert_response :success
      json=JSON.parse response.body
      assert_equal 2, json.count
      assert_equal '16', json[0]['eid']
      assert_equal '4', json[1]['eid']

      get :index, :format => 'json', :order => 'recent'
      assert_response :success
      json=JSON.parse response.body
      assert_equal 2, json.count
      assert_equal '16', json[1]['eid']
      assert_equal '4', json[0]['eid']
    end

    it 'must search by geo' do
      # Defaults to 5 miles
      get :index, :format => 'json', :near => '45.3,-113.4'
      assert_response :success
      json=JSON.parse response.body
      assert_equal 1, json.count
      assert_equal '16', json[0]['eid']

      # Invalid units
      get :index, :format => 'json', :near => '45.3,-113.4', :units => 'invalid'
      assert_response :success
      json=JSON.parse response.body
      assert_equal 1, json.count
      assert_equal '16', json[0]['eid']

      FactoryGirl.create :quake3
      get :index, :format => 'json', :near => '45.3,-113.4'
      assert_response :success
      json=JSON.parse response.body
      assert_equal 1, json.count
      assert_equal '16', json[0]['eid']

      # Expand the radius
      get :index, :format => 'json', :near => '45.3,-113.4', :radius => '25'
      assert_response :success
      json=JSON.parse response.body
      # Should return both now
      assert_equal 2, json.count

      # Change units to km
      get :index, :format => 'json', :near => '45.3,-113.4', :radius => '25', :units => 'km'
      assert_response :success
      json=JSON.parse response.body
      # Radius is effectively cut in half, we should only get one again
      assert_equal 1, json.count
      assert_equal '16', json[0]['eid']
    end

    it 'must search allow multiple search terms' do
      get :index, :format => 'json', :near => '45.3,-113.4', :over => 8
      assert_response :success
      json=JSON.parse response.body
      assert_equal 0, json.count
    end

    it 'must search by since' do
      get :index, :format => 'json', :since => "#{DateTime.strptime("20130101-140334", "%Y%m%d-%H%M%S").to_i}"
      assert_response :success
      json=JSON.parse response.body
      assert_equal 1, json.count
      assert_equal '4', json[0]['eid']
    end

    it 'must search by date' do
      get :index, :format => 'json', :on => "#{DateTime.strptime("20130101-140334", "%Y%m%d-%H%M%S").to_i}"
      assert_response :success
      json=JSON.parse response.body
      assert_equal 0, json.count
      get :index, :format => 'json', :on => "#{DateTime.strptime("20130519-140334", "%Y%m%d-%H%M%S").to_i}"
      assert_response :success
      json=JSON.parse response.body
      assert_equal 1, json.count
      assert_equal '4', json[0]['eid']
    end

    it 'must search by on and since combined' do
      on="#{DateTime.strptime("20130519-150000", "%Y%m%d-%H%M%S").to_i}"
      since=on
      get :index, :format => 'json', :on => on, :since => since
      assert_response :success
      json=JSON.parse response.body
      assert_equal 0, json.count
      since="#{DateTime.strptime("20130519-140000", "%Y%m%d-%H%M%S").to_i}"
      get :index, :format => 'json', :on => on, :since => since
      assert_response :success
      json=JSON.parse response.body
      assert_equal 1, json.count
      assert_equal '4', json[0]['eid']
    end

    it 'must ignore invalid dates' do
      get :index, :format => 'json', :since => 'not_valid'
      assert_response :success
      json=JSON.parse response.body
      assert_equal 2, json.count
    end
  end
end