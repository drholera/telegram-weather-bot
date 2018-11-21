require_relative "./request_handler_base"
require_relative "../../models/user"

class StartHandler < RequestHandlerBase

  def handle
    begin
      user = User.find_by chat_id: @request.chat.id
      if user.nil?
        User.create(chat_id: @request.chat.id).save
      end
      @bot.api.send_message(chat_id: @request.chat.id, text: "Hello, #{@request.from.first_name}")
    rescue Exception => e
      puts e.message
      exit 0
    end
  end

end