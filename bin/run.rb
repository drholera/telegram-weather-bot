require 'telegram/bot'
require File.expand_path('../../lib/utility/file_helper.rb', __FILE__ )
require_relative File.expand_path('../../lib/request_handler/handler_factory', __FILE__)
require_relative File.expand_path('../../lib/request_handler/start_handler', __FILE__)

loop do
  begin
    Telegram::Bot::Client.run('YOUR TOKEN HERE') do |bot|
      bot.listen do |rqst|
        Thread.start(rqst) do |rqst|
          command = rqst.text[1..-1]
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