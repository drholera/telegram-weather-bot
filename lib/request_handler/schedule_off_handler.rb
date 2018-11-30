require_relative 'request_handler_base'

class ScheduleoffHandler < RequestHandlerBase

  def handle
    super
    if @user.enabled?
      @user.schedule_enabled = false
      @user.save
      if !@user.schedule_enabled
        @bot.api.send_message(chat_id: @request.chat.id, text: "Schedule has been disabled.")
      else
        @bot.api.send_message(chat_id: @request.chat.id, text: "Something went wrong. Schedule cannot be disabled at the moment. Please, try again later.")
      end
    else
      @bot.api.send_message(chat_id: @request.chat.id, text: "You must enable bot before using commands. Please, run /start command.")
    end
  end

  def self.description
    '/scheduleOff command. Disabling scheduled forecast.'
  end

end