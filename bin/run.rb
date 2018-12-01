require 'telegram/bot'
require 'logger'
require_relative '../lib/load'
require_relative '../lib/helpers/last_command'
require_relative '../config/config'

include Config
include Loader

# Main loop
loop do
  main_loop
end