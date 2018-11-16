require_relative "./request_handler_base"
require_relative "../../lib/config/config"

class CurrentHandler < RequestHandlerBase
  include Config

  def handle
    if @request.text[0] == "/"
      handle_command
    else
      handle_answer
    end
  end

  def handle_command
    @bot.api.send_message(chat_id: @request.chat.id, text: "Please, tell me where are you located?")
  end

  def handle_answer
    weather = Openweather2.get_weather(city: @request.text)
    if weather
      @bot.api.send_message(chat_id: @request.chat.id, text: weather.city)
    else
      @bot.api.send_message(chat_id: @request.chat.id, text: "Sorry, cannot find your city, try again")
    end
  end

end