$LOAD_PATH.unshift(File.dirname(__FILE__))

require_relative 'weather/weather'
require_relative 'request_handler/handler_factory'
require_relative 'request_handler/start_handler'
require_relative 'request_handler/stop_handler'
require_relative 'request_handler/current_handler'
require_relative 'request_handler/location_handler'
require_relative 'request_handler/forecast_handler'
require_relative '../config'
require_relative '../lib/helpers/weather_extractor'