require_relative '../../../test_helper'
require File.join Rails.root, 'lib/import/earthquake_importer'

describe EarthquakeImporter do
  FLOAT_TOLERANCE=0.00001

  it 'must import quake information' do
    assert_equal 0, Quake.count
    test_data=File.read "#{File.dirname __FILE__}/../../../data/earthquake_sample.csv"
    EarthquakeImporter.send :parse_data, test_data
    assert_equal 2, Quake.count
    q=Quake.where(:eid => '10719904').first
    assert q
    assert_in_delta 1.4, q.magnitude, FLOAT_TOLERANCE
    assert_in_delta 16.60, q.depth, FLOAT_TOLERANCE
    assert_equal 'Southern Yukon Territory, Canada', q.region
    assert_in_delta 61.4977, q.latitude, FLOAT_TOLERANCE
    assert_in_delta 61.4977, q.location[1], FLOAT_TOLERANCE
    assert_in_delta -140.6652, q.longitude, FLOAT_TOLERANCE
    assert_in_delta -140.6652, q.location[0], FLOAT_TOLERANCE
    test_date=DateTime.strptime "20130519-140334", "%Y%m%d-%H%M%S"
    assert_equal test_date, q.time

    # Make sure we don't import duplicates
    EarthquakeImporter.send :parse_data, test_data
    assert_equal 2, Quake.count
  end

  # The USGS web site seems to be a little flaky, so this may occasionally fail.
  it 'must fetch data from the USGS' do
    response=EarthquakeImporter.send :fetch_data
    refute_nil response
    # Do minimal verification that the file format looks ok
    assert response =~ /Src,Eqid,Version,Datetime,Lat,Lon,Magnitude,Depth,NST,Region/
  end
end