class RequestHandlerBase
  attr_accessor :bot, :request, :command

  def initialize(bot, request, command)
    @bot     = bot
    @request = request
    @command = command
  end

  def handle
    raise "It's command handler"
  end

end