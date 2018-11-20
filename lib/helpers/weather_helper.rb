# Thanks https://github.com/TheInvalidNonce/weatherbot-cli-app for an example.
class WeatherHelper

  # Helper function to convert degrees to wind direction
  def self.deg_to_compass(wind_deg)
    val = ((wind_deg.to_f / 22.5) + 0.5).floor
    direction_arr = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
    return direction_arr[(val % 16)]
  end

  # Helper function to convert Fahrenheit to Celsius
  def self.to_celsius(temp_f)
    ((temp_f - 32) * (5.0 / 9.0)).round(2)
  end

end