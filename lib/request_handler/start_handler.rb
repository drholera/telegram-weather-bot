require_relative "./request_handler_base"
require_relative "../../models/user"

class StartHandler < RequestHandlerBase

  def handle
    begin
      new_user = super
      if new_user
        @user.enabled = true
        @user.save
        @bot.api.send_message(chat_id: @request.chat.id, text: "Hello, #{@request.from.first_name}. You've enabled the bot. Please use /help function to see list of available commands")
      else
        @bot.api.send_message(chat_id: @request.chat.id, text: "You have already enabled the bot. Please use /help command to see the list of available commands")
      end
    rescue Exception => e
      @bot.logger.error e.message
    end
  end

  def self.description
    '/start command. Bot enabling.'
  end

end