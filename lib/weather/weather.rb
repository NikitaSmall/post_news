module Weather
  class Weather
    attr_accessor :temp, :weather

    def initialize
      link = 'http://weather.yahooapis.com/forecastrss?w=929398&u=c' #929398 for Odessa
      data = Nokogiri::XML(open(link))

      @temp = data.xpath('//item//yweather:condition')[0]['temp'].to_s
      weather = data.xpath('//item//yweather:condition')[0]['code'].to_i

      @temp = "+#{@temp}" unless @temp.index('-')

      @weather = case weather
                   when 33, 3200
                     'sunny'
                   when 34
                     'moonly'
                   when 30, 28
                     'day_cloud'
                   when 27, 29
                     'night_cloud'
                   when 20
                     'foggy'
                   when 24
                     'windy'
                   when 41, 42, 43
                     'snow'
                   when 37, 38, 39, 40, 47
                     'thunder'
                   when 44
                     'cloud'
                   else
                     weather
                 end
    end
  end
end