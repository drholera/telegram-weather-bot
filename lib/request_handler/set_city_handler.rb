require_relative 'command_answer_handler_base'

class SetcityHandler < CommandAnswerHandlerBase

  def handle_command
    if User.find_by(chat_id: @request.chat.id).enabled?
      @bot.api.send_message(chat_id: @request.chat.id, text: "Please, tell me what city do you want forecasts for?")
      return
    end

    @bot.api.send_message(chat_id: @request.chat.id, text: "Sorry, you didn't enable me. Run /start command to start conversation")
  end

  def handle_answer
    user = User.find_by(chat_id: @request.chat.id)
    user.city = @request.text
    if user.save
      @bot.api.send_message(chat_id: @request.chat.id, text: "Saved! Your selected city is #{user.city}")
    else
      @bot.api.send_message(chat_id: @request.chat.id, text: "Sorry, cannot save it now. Please, try again later")
    end
  end

  def self.description
    '/setCity command. Ask for a city and save it for current user. Will be used for scheduled forecasts'
  end

end