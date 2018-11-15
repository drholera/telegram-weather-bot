require_relative "./request_handler_base"

class StopHandler < RequestHandlerBase

  def handle
    @bot.api.send_message(chat_id: @request.chat.id, text: "Bye, #{@request.from.first_name}")
  end

end