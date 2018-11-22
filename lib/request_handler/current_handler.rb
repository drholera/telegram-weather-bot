require_relative "./request_handler_base"
require_relative "command_answer_handler_base"

class CurrentHandler < CommandAnswerHandlerBase

  def handle_command
    user = User.find_by(chat_id: @request.chat.id)
    if user.enabled?
      @bot.api.send_message(chat_id: @request.chat.id, text: "Please, tell me where are you located?")
      return
    end

    @bot.api.send_message(chat_id: @request.chat.id, text: "Sorry, you didn't enable me. Run /start command to start conversation")
  end

  def handle_answer
    weather = Weather::API.current_weather(@request.text)
    if weather
      @bot.api.send_message(chat_id: @request.chat.id, text: WeatherExtractor.new(weather).get_weather_string)
    else
      @bot.api.send_message(chat_id: @request.chat.id, text: "Sorry, cannot find your city, try again")
    end
  end

end