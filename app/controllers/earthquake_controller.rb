class EarthquakeController < ApplicationController
  respond_to :json

  def index
    if params[:near]
      args=params[:near].split ','
      if args.count >= 2
        lat,long=args.map{|arg| arg.to_f}
        #criteria=Quake.where :location.near => [long,lat]
        #point=Mongoid::Geospatial::Point.new long, lat
        #radius=point.radius 5
        #criteria=Quake.within_circle :location => radius
        #criteria=Quake.where :location.near => Quake.first.location
      end
    else
      criteria=Quake.all
    end
    if params[:over]
      criteria=criteria.gte :magnitude => params[:over]
    end
    on=params[:on] && DateTime.strptime(params[:on], '%s') || nil rescue nil
    since=params[:since] && DateTime.strptime(params[:since], '%s') || nil rescue nil
    if on || since
      end_time=on && on.midnight+1 || DateTime.now+1 # sidestep timezone issues
      start_time=since || on.midnight
      criteria=criteria.between :time => start_time..end_time
    end
    respond_with criteria
  end
end
