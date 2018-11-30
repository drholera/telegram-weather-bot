require 'rubygems'
require 'bundler/setup'
require 'active_record'
require 'mysql2'
require 'yaml'
require_relative 'models/user'
require 'telegram/bot'
require_relative 'lib/weather/weather'
require_relative 'lib/helpers/weather_extractor'

namespace :db do

  desc 'Migrate the database'
  task :migrate do
    connection_details = YAML.load_file('config/database.yml')
    ActiveRecord::Base.establish_connection(connection_details)
    ActiveRecord::MigrationContext.new('db/migrate/').migrate
  end

  desc 'Create the database'
  task :create do
    connection_details = YAML.load_file("config/database.yml")
    admin_connection = connection_details.merge({'database' => 'mysql'})
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.create_database(connection_details["database"])
  end

  desc 'Drop the database'
  task :drop do
    connection_details = YAML.load_file('config/database.yml')
    admin_connection = connection_details.merge({'database' => 'mysql'})
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.drop_database(connection_details["database"])
  end
end

namespace :weather do

  desc 'Run selecting users for forecast'
  task :run_schedule do

    # Connect to database.
    connection_details = YAML.load_file('config/database.yml')
    ActiveRecord::Base.establish_connection(connection_details)

    time = Time.now.strftime('%H:%M')

    file_path = './tmp/cron.log'
    dirname = File.dirname(file_path)
    unless File.directory?(dirname)
      Dir.mkdir(dirname)
    end
    logger = Logger.new(file_path)
    logger.level = Logger::INFO
    logger.info ("Cron has been run at #{time}")

    User.where(['forecast_time = ? and enabled = ? and schedule_enabled = ?', time, true, true]).each do |user|
      weather = Weather::API.current_weather(user.city)
      Telegram::Bot::Client.run(Config::BOT_TOKEN) do |bot|
        bot.api.send_message(chat_id: user.chat_id, text: WeatherExtractor.new(weather).get_weather_string)
      end
    end

  end

end