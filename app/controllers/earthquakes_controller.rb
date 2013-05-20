# Copyright 2013 C. Benson Manica cbmanica(at)gmail.com
#
# This file is part of kobei.
#
# kobei is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class EarthquakesController < ApplicationController
  respond_to :json
  DEFAULT_RADIUS=5
  DEFAULT_UNITS=:mi

  def index
    if params[:near]
      args=params[:near].split ','
      if args.count >= 2
        lat, long=args.map { |arg| arg.to_f }
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
    case params[:order]
      when 'magnitude'
        criteria=criteria.order_by [:magnitude, :desc]
      when 'recent'
        criteria=criteria.order_by [:time, :desc]
    end
    respond_with criteria, :except => [:location, :_id]
  end
end
