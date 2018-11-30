require_relative "./request_handler_base"

class HelpHandler < RequestHandlerBase

  def handle
    begin
      classes = RequestHandlerBase.descendants
      message = ''
      classes.each do |klass|
        description = klass.try('description') + "\n\n" rescue nil
        if description
          message += description
        end
      end

      @bot.api.send_message(chat_id: @request.chat.id, text: message)

    rescue Exception => e
      file_path = '../tmp/error.txt'
      dirname = File.dirname(file_path)
      unless File.directory?(dirname)
        Dir.mkdir(dirname)
      end
      logger = Logger.new(file_path)
      logger.level = Logger::FATAL
      logger.fatal e.message
    end

  end

end