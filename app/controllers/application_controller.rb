class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_layout_info, :set_options

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
    devise_parameter_sanitizer.for(:sign_up) << :avatar
  end

  def set_layout_info
    @time = Russian::strftime(Time.now, "%d %B %Y, %A, %H:%M")
  end

  # def set_weather
    # now we use a 'pretty_weather' gem! (my own)
    # city_name = 'Odesa' # Odessa city_code in Yahoo weather
    # @weather = Weather::Weather.new(city_name)
  # end

  def set_options
    @options = Option.get_options
  end
end
