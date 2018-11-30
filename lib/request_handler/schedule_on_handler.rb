require_relative 'request_handler_base'

class ScheduleonHandler < RequestHandlerBase

  def handle
    super
    if @user.enabled?
      @user.schedule_enabled = true
      @user.save
      if @user.schedule_enabled
        @bot.api.send_message(chat_id: @request.chat.id, text: "Schedule has been enabled. Time: #{@user.forecast_time}. City: #{@user.city}")
      else
        @bot.api.send_message(chat_id: @request.chat.id, text: "Something went wrong. Schedule cannot be enabled at the moment. Please, try again later.")
      end
    else
      @bot.api.send_message(chat_id: @request.chat.id, text: "You must enable bot before using commands. Please, run /start command.")
    end
  end

  def self.description
    '/scheduleon command. Enabling scheduled forecast for previously set city. Will be sent each day at the previously set time.'
  end

end