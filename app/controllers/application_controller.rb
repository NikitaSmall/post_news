class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_layout_info, :set_weather

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
    devise_parameter_sanitizer.for(:sign_up) << :avatar
  end

  def set_layout_info
    @time = Russian::strftime(Time.now, "%d %B %Y, %A, %H:%M")
  end

  def set_weather
    link = 'http://weather.yahooapis.com/forecastrss?w=929398&u=c' #2123260 for Odessa
    data = Nokogiri::XML(open(link))

    @weather = data.xpath('//item//yweather:condition')[0]['temp'].to_s
    @weather = "+#{@weather}" unless @weather.index('-')
  end
end
