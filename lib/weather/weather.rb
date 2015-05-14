module Weather
  class Weather
    attr_accessor :temp, :weather

    def initialize(city_name)
      link = "http://api.openweathermap.org/data/2.5/weather?q=#{city_name}&mode=xml&units=metric" #Odesa
      data = Nokogiri::XML(open(link))

      @temp = data.xpath('//temperature')[0]['value'].to_i.to_s
      weather_code = data.xpath('//weather')[0]['icon']

      @temp = "+#{@temp}" unless @temp.index('-')

      @weather = weather_name(weather_code)
    end

    def weather_name(weather_code)
      case weather_code
        when '01d'
          'sunny'
        when '01n'
          'moonly'
        when '02d'
          'day_cloud'
        when '02n'
          'night_cloud'
        when '50d', '50n'
          'foggy'
        when '10d'
          'day_rain'
        when '10n'
          'night_rain'
        when '09d', '09n'
          'heavy_rain'
        when '13d', '13n'
          'snow'
        when '11d', '11n'
          'thunder'
        when '03d', '03n', '04d', '04n'
          'cloud'
        else
          'good'
      end
    end
  end
end