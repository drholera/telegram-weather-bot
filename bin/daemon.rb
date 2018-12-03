#!/usr/bin/ruby

require 'daemons'

Daemons.run(File.dirname(__FILE__ ) + '/run.rb')