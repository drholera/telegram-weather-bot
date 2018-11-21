# Extracts current weather string from Openweather2::weather object.
class WeatherExtractor
  WEATHER_PROPERTIES = {
      :location_name  => "Your location is: ",
      :temperature    => "Current temperature (℃): ",
      :wind_speed     => "Wind speed (m/s): ",
      :wind_direction => "Wind direction: "
  }

  FORECAST_PROPERTIES = {
      "condition"      => "Sky condition: ",
      "temp"           => "Temperature (℃): ",
      "wind_speed"     => "Wind speed (m/s): ",
      "wind_direction" => "Wind direction: "
  }

  FORECAST_HOURS = [
      24,
      48,
      72
  ]

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

  def get_forecast_string
    result     = ""
    result_arr = {}

    FORECAST_HOURS.each do |hours|
      result_arr["#{hours.to_s}"] = {}
    end

    FORECAST_PROPERTIES.each do |prop_key, prop_value|

      result_arr.each do |hours_key, hours|
        variable                             = prop_key.to_s + hours_key.to_s
        weather_str                          = @weather.instance_variable_get("@#{variable}")
        result_arr[hours_key][prop_key.to_s] = weather_str
      end

    end

    result_arr.each do |hours_key, prop_key|
      case hours_key
      when '24'
        day_name = "Tomorrow"
      when '48'
        day_name = "Day after tomorrow"
      when '72'
        day_name = "After the day after tomorrow"
      else
        day_name = "The other day"
      end

      result += day_name + " forecast:\n\n"
      prop_key.each do |property|
        if FORECAST_PROPERTIES["#{property[0]}"].nil? or property[1].nil?
          next
        end
        result += FORECAST_PROPERTIES["#{property[0]}"] + property[1].to_s + "\n"
      end
      result += " \n\n\n "

    end

    result

  end

end