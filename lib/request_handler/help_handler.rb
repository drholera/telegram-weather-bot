require_relative "./request_handler_base"

class HelpHandler < RequestHandlerBase

  def handle
    begin
      classes = RequestHandlerBase.descendants
      message = ''
      classes.each do |klass|
        description = klass.try('description') + "\n\n" rescue nil
        if description
          message += description
        end
      end

      @bot.api.send_message(chat_id: @request.chat.id, text: message)

    rescue Exception => e
      # @Todo. Add logging in case of error.
      puts e.message
    end

  end

end