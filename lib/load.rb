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
require_relative 'request_handler/set_schedule_time_handler'
require_relative '../config/config'
require_relative '../lib/helpers/weather_extractor'

connection_details = YAML.load_file(File.dirname(__FILE__ ) + '/../config/database.yml')
ActiveRecord::Base.establish_connection(connection_details)

module Loader

  def main_loop
    begin
      Telegram::Bot::Client.run(Config::BOT_TOKEN) do |bot|
        bot.listen do |rqst|
          # @Todo. Move inner functionality to the separate class.
          Thread.start(rqst) do |rqst|
            if rqst.text and rqst.text[0] == "/"
              command = rqst.text[1..-1].downcase
              LastCommand::set_last_command(rqst.chat.id, command)
            else
              command = LastCommand::get_last_command(rqst.chat.id)
            end

            handler_class_name = command[0].capitalize + command[1..-1] + "Handler"
            if HandlerFactory.class_exists?(handler_class_name)
              handler = HandlerFactory.get_instance(handler_class_name, bot, rqst)
              handler.handle
            else
              @bot.api.send_message(chat_id: @request.chat.id, text: "Sorry, cannot find such a command")
            end
          end
        end
      end
    rescue Exception => e
      file_path = '../tmp/error.txt'
      dirname = File.dirname(file_path)
      unless File.directory?(dirname)
        Dir.mkdir(dirname)
      end
      logger = Logger.new(file_path)
      logger.level = Logger::FATAL
      logger.fatal e.message
      exit 0
    end
  end

end