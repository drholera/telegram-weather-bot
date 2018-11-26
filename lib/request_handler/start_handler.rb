require_relative "./request_handler_base"
require_relative "../../models/user"

class StartHandler < RequestHandlerBase

  def handle
    begin
      super
      @bot.api.send_message(chat_id: @request.chat.id, text: "Hello, #{@request.from.first_name}")
    rescue Exception => e
      @bot.logger.error e.message
    end
  end

end