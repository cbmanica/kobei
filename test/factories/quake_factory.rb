FactoryGirl.define do
  factory :quake1, class: Quake do
    eid 4
    latitude 43.3
    longitude 42.2
    location [42.2, 43.3]
    magnitude 3.5
    depth 9.7
    time DateTime.strptime "20130519-140334", "%Y%m%d-%H%M%S"
    region 'Northern Foo'
  end

  factory :quake2, class: Quake do
    eid 16
    latitude 45.3
    longitude -113.4
    location [-113.4, 45.3]
    magnitude 6.8
    depth 14
    time DateTime.strptime "20120519-140334", "%Y%m%d-%H%M%S"
    region 'Southeastern Baz'
  end
end