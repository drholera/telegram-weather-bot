require_relative 'command_answer_handler_base'

class SetScheduleTimeHandler < CommandAnswerHandlerBase

  def handle_command
    @bot.api.send_message(chat_id: @request.chat.id, text: "Please, enter the time you want to receive notifications. " +
        'An important thing. It should be a multiple of 5 minutes. ' +
        'For example: 08:05, 11:15, 14:00. AM/PM time format is acceptable as well. 08:05 AM, 02:00 PM etc.' + "\n\n" +
        "Bot's current time is: #{Time.new.strftime('%H:%M')}")
  end

  def handle_answer
    ampm_pattern = Regexp.new('\b((1[0-2]|0?[0-9]):([0-5][0,5]) ([AaPp][Mm]))').freeze
    common_pattern = Regexp.new('([0-1][0-9]|[2][0-3]):[0-5][0,5]').freeze

    if ampm_pattern.match?(@request.text) or common_pattern.match?(@request.text)
      user = User.find_by(chat_id: @request.chat.id)
      if user
        time = Time.parse(@request.text).strftime('%H:%M')
        user.forecast_time = time
        user.save
        @bot.api.send_message(chat_id: @request.chat.id, text: "Great! Time has been updated. You'll receive a notification each day at #{user.forecast_time}")
        return
      end
    end

    @bot.api.send_message(chat_id: @request.chat.id, text: "Sorry. Time entered in a wrong format, please try again.")

  end

end