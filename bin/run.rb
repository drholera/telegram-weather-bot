require 'telegram/bot'
require File.expand_path('../../lib/request_handler/start_handler', __FILE__ )

loop do
  begin
    Telegram::Bot::Client.run('YOUR TOKEN HERE') do |bot|
      bot.listen do |rqst|
        Thread.start(rqst) do |rqst|
          case rqst.text
          when '/start'
            handler = StartHandler.new(bot, rqst, 'start')
            handler.handle
          when '/stop'
            bot.api.send_message(chat_id: rqst.chat.id, text: "Bye, #{rqst.from.first_name}")
          end
        end
      end
    end
  rescue Exception
    exit 0
  end
end