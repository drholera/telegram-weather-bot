require_relative "command_answer_handler_base"
require_relative "../../lib/weather/weather"

class ForecastHandler < CommandAnswerHandlerBase

  def handle_command
    @bot.api.send_message(chat_id: @request.chat.id, text: "Please, tell me where are you located?")
  end

  def handle_answer
    weather = Weather::API.get_forecast(@request.text)
    if weather
      @bot.api.send_message(chat_id: @request.chat.id, text: WeatherExtractor.new(weather).get_forecast_string)
    else
      @bot.api.send_message(chat_id: @request.chat.id, text: "Sorry, cannot find your city, try again")
    end
  end

  def description
    '/forecast command. Asks a city you want a forecast for. After providing city bot responses with 3-days forecast.'
  end

end