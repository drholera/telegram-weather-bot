require 'telegram/bot'
require 'logger'
require_relative '../lib/load'
require_relative '../lib/helpers/last_command'
require_relative '../config/config'

include Config

loop do
  begin
    Telegram::Bot::Client.run(Config::BOT_TOKEN) do |bot|
      bot.listen do |rqst|
        # @Todo. Move inner functionality to the separate class.
        Thread.start(rqst) do |rqst|
          if rqst.text and rqst.text[0] == "/"
            command = rqst.text[1..-1]
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
    file_path = '../tmp/logs.txt'
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