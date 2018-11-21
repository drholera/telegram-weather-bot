require_relative '../../lib/helpers/weather_helper'
require_relative '../../lib/weather/version'
require_relative '../../config/config'
require 'httparty'

# Thanks https://github.com/TheInvalidNonce/weatherbot-cli-app for the beautiful example.
class Weather::API < WeatherHelper
  include Config

  attr_accessor :temperature, :location, :response_code, :coordinates, :country, :location_name, :temp_avg, :temp_celsius, :condition, :cloudiness, :humidity, :wind_speed, :wind_direction, :report_time, :google_maps, :google_maps_link, :sunrise, :sunset, :hr24_dt, :hr48_dt, :hr72_dt, :temp24, :temp48, :temp72, :condition24, :condition48, :condition72, :cloudiness24, :cloudiness48, :cloudiness72, :humidity24, :humidity48, :humidity72, :wind_speed24, :wind_speed48, :wind_speed72, :wind_direction24, :wind_direction48, :wind_direction72

  @@locations = []

  def initialize
    @location = location
    @@locations << self
  end

  def self.locations
    @@locations
  end

  # Takes user input to enter into URL query & gets current weather conditions in imperial units
  def self.current_weather(location)
    # query sample: 'https://api.openweathermap.org/data/2.5/weather?q=new+york&appid=3207703ee5d0d14e6b6a53d10071018f&units=imperial'
    response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{Config::OPEN_WEATHER_TOKEN}&units=#{Config::UNITS}")
    get_weather(response)
  end

  def self.current_weather_location(lat, lon)
    # query sample: 'https://api.openweathermap.org/data/2.5/weather?q=new+york&appid=3207703ee5d0d14e6b6a53d10071018f&units=imperial'
    response = HTTParty.get("https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=#{Config::OPEN_WEATHER_TOKEN}&units=#{Config::UNITS}")
    get_weather(response)
  end

  def self.get_weather(response)
    parsed                 = response.parsed_response
    @current               = self.new
    @current.response_code = parsed["cod"]

    # Check for invalid entry
    if @current.response_code === "404"
      puts "\n\nInvalid location, please enter a valid location.\n\n"
      return
    else
      # Assign attributes to current weather object
      @current.coordinates   = parsed["coord"].values.reverse.join(", ")
      @current.location_name = parsed["name"]
      @current.report_time   = Time.at(parsed["dt"])
      @current.temp_avg      = parsed["main"]["temp"]
      @current.condition     = parsed["weather"].first["description"]
      @current.cloudiness    = parsed["clouds"]["all"]
      # @current.pressure = parsed["main"]["pressure"]
      @current.humidity       = parsed["main"]["humidity"]
      @current.wind_speed     = parsed["wind"]["speed"]
      @current.sunrise        = Time.at(parsed["sys"]["sunrise"])
      @current.sunset         = Time.at(parsed["sys"]["sunset"])
      @current.wind_direction = deg_to_compass(parsed["wind"]["deg"])
      @current.temp_celsius   = to_celsius(parsed["main"]["temp"])
      @current.temperature    = parsed["main"]["temp"]

      # Open query in browser to Google Maps
      @current.google_maps = "https://www.google.com/maps/place/#{@current.coordinates.gsub(" ", "")}"
      @google_maps_link    = @current.google_maps

      # Check for odd locations with no country key
      if parsed.fetch("sys").has_key?("country")
        @current.country = parsed["sys"]["country"]
      else
        @current.country = nil
      end


    end

    @current
  end


  # Takes user input to enter into URL query for 3 day @current in imperial units
  def self.get_forecast(location)
    # query sample: https://api.openweathermap.org/data/2.5/@current?q=new+york&appid=3207703ee5d0d14e6b6a53d10071018f&units=imperial
    response = HTTParty.get("https://api.openweathermap.org/data/2.5/forecast?q=#{location}&appid=#{Config::OPEN_WEATHER_TOKEN}&units=#{Config::UNITS}")
    parsed   = response.parsed_response
    @current = self.new

    @current.response_code = parsed["cod"]

    # Check for invalid entry
    if @current.response_code === "404"
      puts "\n\nInvalid location, please enter a valid location.\n\n"
      return
    else
      @current.location_name = parsed["city"]["name"]
      # 24/48/72hr date
      @current.hr24_dt = parsed["list"][8]["dt_txt"]
      @current.hr48_dt = parsed["list"][16]["dt_txt"]
      @current.hr72_dt = parsed["list"][24]["dt_txt"]
      # 24/48/72hr temp
      @current.temp24 = parsed["list"][8]["main"]["temp"]
      @current.temp48 = parsed["list"][16]["main"]["temp"]
      @current.temp72 = parsed["list"][24]["main"]["temp"]
      # 24/48/72hr condition
      @current.condition24 = parsed["list"][8]["weather"][0]["description"]
      @current.condition48 = parsed["list"][16]["weather"][0]["description"]
      @current.condition72 = parsed["list"][24]["weather"][0]["description"]
      # 24/48/72hr cloudiness
      @current.cloudiness24 = parsed["list"][8]["clouds"]["all"]
      @current.cloudiness48 = parsed["list"][16]["clouds"]["all"]
      @current.cloudiness72 = parsed["list"][24]["clouds"]["all"]
      # 24/48/72hr humidity
      @current.humidity24 = parsed["list"][8]["main"]["humidity"]
      @current.humidity48 = parsed["list"][16]["main"]["humidity"]
      @current.humidity72 = parsed["list"][24]["main"]["humidity"]
      # 24/48/72hr wind speed & direction
      @current.wind_speed24     = parsed["list"][8]["wind"]["speed"]
      @current.wind_speed48     = parsed["list"][16]["wind"]["speed"]
      @current.wind_speed72     = parsed["list"][24]["wind"]["speed"]
      @current.wind_direction24 = deg_to_compass(parsed["list"][8]["wind"]["deg"])
      @current.wind_direction48 = deg_to_compass(parsed["list"][16]["wind"]["deg"])
      @current.wind_direction72 = deg_to_compass(parsed["list"][24]["wind"]["deg"])

      @current
    end

    # # Output 3 day @current
    # puts "\n-------------------------------\n"
    # puts "\n\nIn 24 Hours:"
    # puts "\nReport Time:      #{@current.hr24_dt}"
    # puts "Location:         #{@current.location_name},  #{@current.country}"
    # puts "Google Maps:      #{@current.google_maps}"
    # puts "\nTemperature:      #{@current.temp24}ºF / #{toCelsius(@current.temp24)}ºC"
    # puts "Condition:        #{@current.condition24.capitalize}"
    # puts "Cloudiness:       #{@current.cloudiness24}%"
    # puts "\nHumidity:         #{@current.humidity24}%"
    # puts "Wind Speed:       #{@current.wind_speed24} mph"
    # puts "Wind Direction:   #{@current.wind_direction24}"
    #
    # puts "\n-------------------------------\n"
    # puts "\n\nIn 48 Hours:"
    # puts "\nReport Time:      #{@current.hr48_dt}"
    # puts "Location:         #{@current.location_name},  #{@current.country}"
    # puts "Google Maps:      #{@current.google_maps}"
    # puts "\nTemperature:      #{@current.temp48}ºF / #{toCelsius(@current.temp48)}ºC"
    # puts "Condition:        #{@current.condition48.capitalize}"
    # puts "Cloudiness:       #{@current.cloudiness48}%"
    # puts "\nHumidity:         #{@current.humidity48}%"
    # puts "Wind Speed:       #{@current.wind_speed48} mph"
    # puts "Wind Direction:   #{@current.wind_direction48}"
    #
    # puts "\n-------------------------------\n"
    # puts "\n\nIn 72 Hours:"
    # puts "\nReport Time:      #{@current.hr72_dt}"
    # puts "Location:         #{@current.location_name}, #{@current.country}"
    # puts "Google Maps:      #{@current.google_maps}"
    # puts "\nTemperature:      #{@current.temp72}ºF / #{toCelsius(@current.temp72)}ºC"
    # puts "Condition:        #{@current.condition72.capitalize}"
    # puts "Cloudiness:       #{@current.cloudiness72}%"
    # puts "\nHumidity:         #{@current.humidity72}%"
    # puts "Wind Speed:       #{@current.wind_speed72} mph"
    # puts "Wind Direction:   #{@current.wind_direction72}"

  end

  # Method to open link in Google Maps depending on OS
  def self.open_link
    link = @google_maps_link
    if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
      system "start #{link}"
    elsif RbConfig::CONFIG['host_os'] =~ /darwin/
      system "open #{link}"
    elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
      system "xdg-open #{link}"
    end
  end


end