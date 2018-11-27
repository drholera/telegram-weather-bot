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
      # If new user has been created - return true.
      true
    else
      # Return false if bot is already enabled for a user.
      false
    end
  end

  def self.description
    raise "Method's description. Will be user for /help command"
  end

  # Helper function for getting all the descendants of the base class.
  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

end