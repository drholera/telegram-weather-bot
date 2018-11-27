$LOAD_PATH.unshift(File.dirname(__FILE__))

require_relative 'weather/weather'
require_relative 'request_handler/handler_factory'
require_relative 'request_handler/start_handler'
require_relative 'request_handler/stop_handler'
require_relative 'request_handler/current_handler'
require_relative 'request_handler/location_handler'
require_relative 'request_handler/forecast_handler'
require_relative 'request_handler/help_handler'
require_relative 'request_handler/set_city_handler'
require_relative 'request_handler/schedule_on_handler'
require_relative 'request_handler/schedule_off_handler'
require_relative '../config/config'
require_relative '../lib/helpers/weather_extractor'

connection_details = YAML.load_file('../config/database.yml')
ActiveRecord::Base.establish_connection(connection_details)