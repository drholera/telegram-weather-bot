require_relative "command_answer_handler_base"
require "telegram/bot"

class LocationHandler < CommandAnswerHandlerBase

  def handle_command
    keyboard = Telegram::Bot::Types::KeyboardButton.new(text: "Please, show me your location", request_location: true)
    markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: keyboard, one_time_keyboard: true)
    bot.api.send_message(chat_id: @request.chat.id, text: "Where are you?", reply_markup: markup)
  end

  def handle_answer
    weather = Openweather2.get_weather(lat: @request.location.latitude, lon: @request.location.longitude, units: Config::UNITS)
    if weather
      @bot.api.send_message(chat_id: @request.chat.id, text: WeatherExtractor.new(weather).get_weather_string)
    else
      @bot.api.send_message(chat_id: @request.chat.id, text: "Sorry, cannot find your location")
    end
  end

end