# Extracts current weather string from Openweather2::weather object.
class WeatherExtractor
  WEATHER_PROPERTIES = {
      :location_name => "Your location is: ",
      :temperature => "Current temperature (℃): ",
      :wind_speed => "Wind speed (m/s): ",
      :rain => "Rain: ",
      :snow => "Snow: "
  }

  attr_accessor :weather, :complete_weather_string

  def initialize(weather)
    if weather.is_a?(Weather::API)
      @weather = weather
    else
      raise "weather object is expected here"
    end
  end

  def get_weather_string
    result = ""

    WEATHER_PROPERTIES.each do |key, value|
      current_property = @weather.instance_variable_get("@#{key}")
      if current_property.nil?
        next
      end

      result += value + current_property.to_s + "\n"

    end

    result
  end

end