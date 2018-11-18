$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'openweather2'

require_relative 'request_handler/handler_factory'
require_relative 'request_handler/start_handler'
require_relative 'request_handler/stop_handler'
require_relative 'request_handler/current_handler'
require_relative 'request_handler/location_handler'
require_relative '../config'
require_relative '../lib/helpers/weather_extractor'


Openweather2.configure do |config|
  config.endpoint = 'http://api.openweathermap.org/data/2.5/weather'
  config.apikey = Config::OPEN_WEATHER_TOKEN
end