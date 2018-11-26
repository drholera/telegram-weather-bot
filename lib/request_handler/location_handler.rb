require_relative "command_answer_handler_base"
require "telegram/bot"

class LocationHandler < CommandAnswerHandlerBase

  def handle_command
    keyboard = Telegram::Bot::Types::KeyboardButton.new(text: "Please, show me your location", request_location: true)
    markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: keyboard, one_time_keyboard: true)
    bot.api.send_message(chat_id: @request.chat.id, text: "Where are you?", reply_markup: markup)
  end

  def handle_answer
    weather = Weather::API.current_weather_location(@request.location.latitude, @request.location.longitude)
    if weather
      @bot.api.send_message(chat_id: @request.chat.id, text: WeatherExtractor.new(weather).get_weather_string)
    else
      @bot.api.send_message(chat_id: @request.chat.id, text: "Sorry, cannot find your location")
    end
  end

  def self.description
    '/location command. Asks phone current location and provides current weather for the location'
  end

end