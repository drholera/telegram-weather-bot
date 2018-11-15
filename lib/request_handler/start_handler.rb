require_relative "./request_handler_base"

class StartHandler < RequestHandlerBase

  def handle
    @bot.api.send_message(chat_id: @request.chat.id, text: "Hello, #{@request.from.first_name}")
  end

end