require_relative '../../config/config'

class RequestHandlerBase
  include Config

  attr_accessor :bot, :request

  def initialize(bot, request)
    @bot     = bot
    @request = request
  end

  def handle
    user = User.find_by chat_id: @request.chat.id
    if user.nil?
      User.create(chat_id: @request.chat.id, enabled: true).save
    elsif user.enabled?
      @bot.api.send_message(chat_id: @request.chat.id, text: "You have already enabled the bot. Please use /help command to see the list of available commands")
      return
    end
    user.enabled = true
    user.save
  end

end