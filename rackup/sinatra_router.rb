require 'multi_json'
require 'sinatra'
require 'telegram/bot'
require 'colorize'
#require 'awesome_print'

require_relative '../lib/utilities'
require_relative '../lib/loader'

include Loader 

#
# load bots in memory. return a lookup table
# to retrieve object method :update, from a passed token as key
#
set lookup: Loader.lookup

# deserialize JSON data from request body 
def json_load(request_body)
  request_body.rewind
  body = request_body.read

  MultiJson.load body
end  

#
# HTTPS POST webhook endpoint(s)
#
post '/:token' do | token |

  # retrieve name, method object pair from lookup table
  bot = settings.lookup[token.to_sym]
  
  if bot
    # SUCCESS: token found in look-up table 

    data = json_load request.body
    #ap data

    # routing dispatch: call object method run-time execution
    bot[:method].call data 

    # WARNING: # it's better to do not write/log tokens in clear on a log files
    puts "#{time_now}\t#{bot[:name]}\t#{data['update_id']}".green #{data['message']['message_id']}
    status 200
  else
    # WARNING: token not found in look-up table!
    $stderr.puts "WARNING. unexpected/uknown token: #{token}".red
    status 400
  end
end
