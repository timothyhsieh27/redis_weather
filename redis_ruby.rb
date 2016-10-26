require 'redis'
require 'httparty'
require 'json'
require_relative 'class'

def main
  variable = Class.new
  variable.get_zipcode
  variable.set_response
end

main if __FILE__ == $PROGRAM_NAME
