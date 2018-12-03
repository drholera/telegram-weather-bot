# Telegram weather bot
It's a simple telegram bot which can show current weather according to your location,
 showing forecasts for 3 days and enable/disable scheduling weather broadcasting.
 
 
First of all you need to update...
### Configuration

File config/config.rb
```ruby 
   # Telegram bot token
   BOT_TOKEN = "YOUR_TOKEN_HERE"
 
   # OpenWeather API token
   OPEN_WEATHER_TOKEN = "YOUR_TOKEN_HERE"
 
   # Units are used by OpenWeather API.
   UNITS = "metric"   
```

File config/database.yml
```yml
    adapter: mysql2
    database: YOUR_DATABASE_NAME
    encoding: utf8
    pool: 5
    timeout: 5000
    username: YOUR_MYSQL_USER
    password: YOUR_MYSQL_PASSWORD
```

### Installation

1. Set up configuration with proper info.
2. Run ``` bundle ``` command to install required gems.
3. Run ``` rake db:create ``` for database creation.
4. Run ``` rake db:migrate ``` for creating **users** table.
5. Run ``` ruby bin/run.rb ``` for bot start

If you want to use bot as system service (daemon) you should use command

``` ruby bin/daemon.rb start ```

Other daemon commands you can find in [Daemons gem](https://github.com/thuehlinger/daemons) documentation.

### Available commands

/stop command. Stop bot. It won't handle commands after this command

/start command. Bot enabling.

/location command. Asks phone current location and provides current weather for the location

/current command. Asks a city you want a forecast for. After providing city bot responses with current weather.

/forecast command. Asks a city you want a forecast for. After providing city bot responses with 3-days forecast.

/setscheduletime command. Set time for a daily schedule.

/scheduleoff command. Disabling scheduled forecast.

/scheduleon command. Enabling scheduled forecast for previously set city. Will be sent each day at the previously set time.

/setcity command. Ask for a city and save it for current user. Will be used for scheduled forecasts

/help command. Shows this list.