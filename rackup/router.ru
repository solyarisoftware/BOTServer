require 'rack'
require_relative 'router.rb'

# Disable Thin logging
# Thin::Logging.silent = true

# Disable useless rack logger completely! Yay, yay!
# http://gromnitsky.blogspot.it/2012/04/how-to-disable-rack-logging-in-sinatra.html
module Rack
  class CommonLogger
    def call(env)
      # do nothing
      @app.call(env)
    end
  end
end

run WebhookRouter 
#Rack::Server.start app: WebhookRouter 
