require 'telegram/bot'
require_relative '../lib/load'
require_relative '../lib/helpers/last_command'
require_relative '../lib/config/config'

include Config

loop do
  begin
    Telegram::Bot::Client.run(Config::BOT_TOKEN) do |bot|
      bot.listen do |rqst|
        Thread.start(rqst) do |rqst|
          if rqst.text[0] == "/"
            command = rqst.text[1..-1]
            LastCommand::set_last_command(rqst.chat.id, command)
          else
            command = LastCommand::get_last_command(rqst.chat.id)
          end

          handler_class_name = command.capitalize + "Handler"
          if HandlerFactory.class_exists?(handler_class_name)
            handler = HandlerFactory.get_instance(handler_class_name, bot, rqst)
            handler.handle
          else
            puts "Error"
            exit 0
          end
        end
      end
    end
  rescue Exception => e
    puts e.message
    exit 0
  end
end