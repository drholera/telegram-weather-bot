require_relative '../../config/config'

class RequestHandlerBase
  include Config

  attr_accessor :bot, :request, :user

  def initialize(bot, request)
    @bot     = bot
    @request = request
    @user = User.find_by chat_id: @request.chat.id
  end

  def handle
    if @user.nil?
      @user = User.create(chat_id: @request.chat.id, enabled: true)
    elsif @user.enabled?
      @bot.api.send_message(chat_id: @request.chat.id, text: "You have already enabled the bot. Please use /help command to see the list of available commands")
      return false
    end
    @user.enabled = true
    @user.save

    # If new user has been created - return true.
    true
  end

  def description
    raise "Method's description. Will be user for /help command"
  end

end