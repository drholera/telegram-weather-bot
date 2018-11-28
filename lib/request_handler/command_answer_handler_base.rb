require_relative 'request_handler_base'

class CommandAnswerHandlerBase < RequestHandlerBase

  def handle
    super
    if @user.enabled?
      if @request.text and @request.text[0] == "/"
        handle_command
      else
        handle_answer
      end
    else
      @bot.api.send_message(chat_id: @request.chat.id, text: "You must enable bot before using commands. Please, run /start command.")
    end
  end

  def handle_command
    raise "Command handler should be implemented here"
  end

  def handle_answer
    raise "Answer handler should be implemented here"
  end

end