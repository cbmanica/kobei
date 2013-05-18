class EarthquakeController < ApplicationController
  respond_to :json
  EARTH_RADIUS=3959 # miles

  def index
    if params[:near]
      args=params[:near].split ','
      if args.count >= 2
        lat,long=args.map{|arg| arg.to_f}
        criteria=Quake.where(:location => {"$within" => {"$centerSphere" => [[long,lat], dist_radius.fdiv(EARTH_RADIUS)]}})
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

  private
  def dist_radius
    5 # miles
  end
end
