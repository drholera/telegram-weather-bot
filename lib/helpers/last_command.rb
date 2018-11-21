class LastCommand
  @@last_command = {}

  def self.set_last_command(chat_id, command)
    @@last_command[chat_id] = command
  end

  def self.get_last_command(chat_id)
    @@last_command[chat_id]
  end

end