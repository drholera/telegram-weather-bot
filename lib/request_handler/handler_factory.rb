class HandlerFactory

  def self.get_instance(class_name, bot, rqst)
    if class_exists?(class_name)
      Kernel.const_get(class_name).new(bot, rqst)
    else
      puts "Handler For this command doesn't exist yet"
      return false
    end
  end

  def self.class_exists?(class_name)
    klass = Kernel.const_get(class_name)
    return klass.is_a?(Class)
  rescue NameError => e
    puts e.message
    return false
  end

end