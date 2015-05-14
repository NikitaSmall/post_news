module ApplicationHelper
  def tag_selected(tag)
    if params[:tag]
      if params[:tag] == tag
        return 'btn-info'
      end
    end
    'btn-default'
  end

  def size(index)
    num = index % 5
    return 'big' if num <= 2 && num != 0
    'small'
  end

  def weather_selector(weather)
    icon = case weather
             when 'sunny'
               '<i class="wi wi-day-sunny"></i>'
             when 'moonly'
               '<i class="wi wi-night-clear"></i>'
             when 'day_cloud'
               '<i class="wi wi-day-cloudy"></i>'
             when 'night_cloud'
               '<i class="wi wi-night-alt-cloudy"></i>'
             when 'foggy'
               '<i class="wi wi-dust"></i>'
             when 'day_rain'
               '<i class="wi wi-day-showers"></i>'
             when 'night_rain'
               '<i class="wi wi-night-alt-sprinkle"></i>'
             when 'heavy_rain'
               '<i class="wi wi-sprinkle"></i>'
             when 'windy'
               '<i class="wi wi-cloudy-gusts"></i>'
             when 'snow'
               '<i class="wi wi-snow"></i>'
             when 'thunder'
               '<i class="wi wi-thunderstorm"></i>'
             when 'cloud'
               '<i class="wi wi-cloudy"></i>'
             when 'good'
               '<i class="wi wi-thermometer-exterior"></i>'
             else
               '<i class="wi wi-alien"></i>'
           end
    icon
  end
end
