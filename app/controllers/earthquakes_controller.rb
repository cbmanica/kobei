class EarthquakesController < ApplicationController
  respond_to :json
  EARTH_RADIUS=3959 # miles
  DEFAULT_RADIUS=5
  DEFAULT_UNITS=:mi

  def index
    if params[:near]
      args=params[:near].split ','
      if args.count >= 2
        lat,long=args.map{|arg| arg.to_f}
        # Friendly defaults if user passes invalid values
        radius=params[:radius] && params[:radius].to_i || DEFAULT_RADIUS
        units=params[:units] && params[:units].to_sym || DEFAULT_UNITS
        criteria=Quake.near_geo lat, long, radius, units
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
    respond_with criteria, :except => :location
  end
end
