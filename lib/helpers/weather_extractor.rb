require 'openweather2'

class WeatherExtractor
  WEATHER_PROPERTIES = {
      "city" => "Your city is: ",
      :temperature => "Current temperature (℃): ",
      :wind_speed => "Wind speed (m/s): ",
      :rain => "Rain: ",
      :snow => "Snow: "
  }

  attr_accessor :weather, :complete_weather_string

  def initialize(weather)
    if weather.is_a?(Openweather2::Weather)
      @weather = weather
    else
      raise "Weather object is expected here"
    end
  end

  def get_weather_string
    result = ""

    WEATHER_PROPERTIES.each do |key, value|
      current_property = @weather.instance_variable_get("@#{key}")
      if current_property.nil?
        next
      end

      result += value + current_property.to_s
      result += "\n"

    end

    result
  end

end