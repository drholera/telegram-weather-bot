require_relative "./request_handler_base"
require_relative "../../models/user"

class StartHandler < RequestHandlerBase

  def handle
    begin
      new_user = super
      if new_user
        @bot.api.send_message(chat_id: @request.chat.id, text: "Hello, #{@request.from.first_name}")
      end
    rescue Exception => e
      @bot.logger.error e.message
    end
  end

  def self.description
    '/start command. Bot enabling.'
  end

end