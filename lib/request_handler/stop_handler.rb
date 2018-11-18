require_relative "./request_handler_base"
require_relative "../../lib/helpers/last_command"

class StopHandler < RequestHandlerBase

  def handle
    # First of all - clear a last command storage for current chat.
    LastCommand::set_last_command(@request.chat.id, nil)
    # Good bye.
    @bot.api.send_message(chat_id: @request.chat.id, text: "Bye, #{@request.from.first_name}")
  end

end