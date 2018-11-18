require_relative "./request_handler_base"
require_relative "command_answer_handler_base"

class CurrentHandler < CommandAnswerHandlerBase

  def handle_command
    @bot.api.send_message(chat_id: @request.chat.id, text: "Please, tell me where are you located?")
  end

  def handle_answer
    weather = Openweather2.get_weather(city: @request.text, units: Config::UNITS)
    if weather
      @bot.api.send_message(chat_id: @request.chat.id, text: WeatherExtractor.new(weather).get_weather_string)
    else
      @bot.api.send_message(chat_id: @request.chat.id, text: "Sorry, cannot find your city, try again")
    end
  end

end