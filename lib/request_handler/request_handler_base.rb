require 'openweather2'
require_relative '../../config'

class RequestHandlerBase
  include Config

  attr_accessor :bot, :request

  def initialize(bot, request)
    @bot     = bot
    @request = request

    Openweather2.configure do |config|
      config.endpoint = 'http://api.openweathermap.org/data/2.5/weather'
      config.apikey = Config::OPEN_WEATHER_TOKEN
    end

  end

  def handle
    raise "It's command handler"
  end

end