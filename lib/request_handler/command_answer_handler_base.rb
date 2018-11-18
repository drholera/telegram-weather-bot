require_relative 'request_handler_base'

class CommandAnswerHandlerBase < RequestHandlerBase

  def handle
    if @request.text and @request.text[0] == "/"
      handle_command
    else
      handle_answer
    end
  end

  def handle_command
    raise "Command handler should be implemented here"
  end

  def handle_answer
    raise "Answer handler should be implemented here"
  end

end