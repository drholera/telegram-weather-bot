require "openweather2"
require_relative "./request_handler_base"

class CurrentHandler < RequestHandlerBase

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
    Openweather2.configure do |config|
      config.endpoint = 'http://api.openweathermap.org/data/2.5/weather'
      config.apikey = "YOUR TOKEN HERE"
    end
    weather = Openweather2.get_weather(city: @request.text)
    if weather
      @bot.api.send_message(chat_id: @request.chat.id, text: weather.city)
    else
      @bot.api.send_message(chat_id: @request.chat.id, text: "Sorry, cannot find your city, try again")
    end
  end

end