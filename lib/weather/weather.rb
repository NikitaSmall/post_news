module Weather
  class Weather
    attr_accessor :temp, :weather

    def initialize
      link = 'http://weather.yahooapis.com/forecastrss?w=929398&u=c' #929398 for Odessa
      data = Nokogiri::XML(open(link))

      @temp = data.xpath('//item//yweather:condition')[0]['temp'].to_s
      @weather = data.xpath('//item//yweather:condition')[0]['code'].to_s

      @temp = "+#{@temp}" unless @temp.index('-')
    end
  end
end