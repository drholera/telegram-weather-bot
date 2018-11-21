require_relative '../../config/config'

class RequestHandlerBase
  include Config

  attr_accessor :bot, :request

  def initialize(bot, request)
    @bot     = bot
    @request = request
  end

  def handle
    raise "It's command handler"
  end

end