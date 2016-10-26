require 'redis'
require 'httparty'
require 'json'
require 'open-uri'
#
class Class
  def initialize
    @redis = Redis.new
  end

  def get_zipcode
    puts 'Which zipcode would you like a report for?'
    @zipcode = gets.chomp
  end

  def set_response
    puts 'Which report would you like?'
    puts 'Please type Conditions, Forecast, Daylight, Alerts, or Hurricanes: '
    @response = gets.chomp
    select_mode
  end

  def select_mode
    loop do
      if @response.downcase == 'conditions'
        run_conditions
      elsif @response.downcase == 'forecast'
        run_forecast
      elsif @response.downcase == 'daylight'
        run_daylight
      elsif @response.downcase == 'alerts'
        run_alerts
      elsif @response.downcase == 'hurricanes'
        run_hurricanes
      else
        puts 'Please select a valid report: '
        @response = gets.chomp
      end
    end
  end

# url = "http://api.wunderground.com/api/b1c58af1b85cc78f/conditions/forecast10day/astronomy/alerts/currenthurricane/q/#{@zipcode}.json"

  def run_conditions
    # @redis.set(@response, 'Here is your ' + @response + ' report!')
    # puts @redis.get(@response)
    show_conditions
    get_zipcode
    set_response
  end

  def run_daylight
    show_daylight
    get_zipcode
    set_response
  end

  def run_hurricanes
    show_hurricanes
    get_zipcode
    set_response
  end

  # def show_conditions
  # open('http://api.wunderground.com/api/b1c58af1b85cc78f/geolookup/conditions/q/27713.json') do |f|
  #   json_string = f.read
  #   parsed_json = JSON.parse(json_string)
  #   state = parsed_json['location']['state']
  #   city = parsed_json['location']['city']
  #   temp_f = parsed_json['current_observation']['temp_f']
  #   print "Current temperature in #{city}, #{state} is: #{temp_f} degrees. \n"
  # end
  # end

  def show_conditions
    @conurl = HTTParty.get("http://api.wunderground.com/api/b1c58af1b85cc78f/conditions/q/#{@zipcode}.json")
    full = @conurl['current_observation']['display_location']['full']
    temp_f = @conurl['current_observation']['temp_f']
    print "Current temperature in #{full} is: #{temp_f}\n"
    # data = HTTParty.get(conurl).parsed_response
    # open("#{conurl}") do |f|
    #   json_string = f.read
    #   parsed_json = JSON.parse(json_string)
    # end
  end

  def run_forecast
    @forurl = HTTParty.get("http://api.wunderground.com/api/b1c58af1b85cc78f/forecast10day/q/#{@zipcode}.json")
    full = @forurl['current_observation']['display_location']['full']
    temp_f = @forurl['current_observation']['temp_f']
    print "Current temperature in #{full} is: #{temp_f}\n"
  end

  def show_daylight
    @dayurl = HTTParty.get("http://api.wunderground.com/api/b1c58af1b85cc78f/astronomy/q/#{@zipcode}.json")
    risehour = @dayurl['moon_phase']['sunrise']['hour']
    riseminute = @dayurl['moon_phase']['sunrise']['minute']
    sethour = @dayurl['moon_phase']['sunset']['hour']
    setminute = @dayurl['moon_phase']['sunset']['minute']
    puts "Sunrise at this zipcode is at #{risehour}:#{riseminute} AM."
    puts "Sunset at this zipcode is at #{sethour}:#{setminute} PM."
  end

  def run_alerts
    @redis.set(@response, 'Here is your ' + @response + ' report!')
    puts @redis.get(@response)
    set_response
  end

  def show_hurricanes
    @hururl = HTTParty.get("http://api.wunderground.com/api/b1c58af1b85cc78f/currenthurricane/q/view.json")
    array = @hururl.first

    p array.class
  end
end
# def exists?
#   @response.casecmp('conditions') ||
#     @response.casecmp('conditions') ||
#     @response.casecmp('daylight') ||
#     @response.casecmp('alerts') ||
#     @response.casecmp('hurricanes')
# end

# def run_valid
#   run_conditions if @response.casecmp('conditions')
#   run_forecast if @response.casecmp('forecast')
#   run_daylight if @response.casecmp('daylight')
#   run_alerts if @response.casecmp('alerts')
#   run_hurricanes if @response.casecmp('hurricanes')
# end
