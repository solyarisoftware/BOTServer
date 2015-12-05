require 'rake'
require_relative 'lib/config'
require_relative 'lib/tokens'
require_relative 'lib/webhook'
require_relative 'lib/certificate'
require_relative 'lib/apptemplate'
require_relative 'lib/proxy'
require_relative 'lib/server'

include Config
include Proxy
include Server
include Certificate
include Tokens
include Webhook
include AppTemplate

#
# DEFAULT
#

# http://stackoverflow.com/a/11320444/1786393
Rake::TaskManager.record_task_metadata = true

# http://stackoverflow.com/a/11320444/1786393
task :default do
  Rake::application.options.show_tasks = :tasks  # this solves sidewaysmilk problem
  Rake::application.options.show_task_pattern = //
  Rake::application.display_tasks_and_comments
end

#
# APP
#
namespace :app do
  desc "Create bot app template for given token"
  task :new, [:token] do |t, args|
    bot_name = Tokens.find_bot_name(args.token)
    AppTemplate.build_app(bot_name, args.token, Config.app_directory)
  end
end

#
# TOKENS
#
namespace :tokens do
  desc "Verify if tokens are valid, online querying Telegram Server"
  task :test do
    Tokens.check
  end

  desc "Show tokens configuration file: #{Config.tokens_config_file}"
  task :show do
    sh Tokens.show
  end
end

#
# WEBHOOK
#
namespace :webhook do
  desc "Set webhook for a given token."
  task :set, [:token] do |t, args|
    Server.check(verbose:false)
    certificate = Server.certificate_file_pem
    Webhook.set(args.token, certificate )
  end

  desc "Reset webhook for a given token"
  task :reset, [:token] do |t, args|
    Server.check(verbose:false)
    certificate = Server.certificate_file_pem
    Webhook.reset(args.token, certificate )
  end
end

#
# CERTIFICATE
#
namespace :certificate do
  desc "Create SSL certificate"
  task :new do 
    Server.check(verbose:false)
    puts "Create private_key, public certificate pair.\nmodify and run yourself the command below:\n\n"
    # sh
    puts Certificate.create_pair_command(Server.certificate_file_key, 
                                         Server.certificate_file_pem,
                                         Server.host).green
  end

  desc "Show public certificate"
  task :show do 
    Server.check(verbose:false)
    sh Certificate.show_command(Server.certificate_file_pem)
  end
end

#
# PROXY SERVER
#
namespace :proxy do
  namespace :config do
    desc "Generate nginx proxy SSL configuration from server.yml data."
    task :new do
      Server.check(verbose: false)
      puts "\nSSL config section to insert in your nginx config file (/etc/nginx/sites-available/default):\n\n"
      puts Proxy.config.green
    end  
  end

  desc "Start proxy server"
  task :start do 
    sh Proxy.start
  end

  desc "Restart proxy server"
  task :restart do 
    sh Proxy.restart
  end

  desc "Stop proxy server"
  task :stop do 
    sh Proxy.stop
  end
end

#
# RACK SERVER
# 
namespace :server do
  namespace :config do
    desc "Show server configuration: #{Config.server_config_file}"
    task :show do
      sh Server.show
    end

    desc "Check server configuration: #{Config.server_config_file}"
    task :test do
      sh Server.show
      puts
      Server.check
    end
  end

  desc "Start rack server"
  task :start do 
    Server.check(verbose:false)
    sh Server.start
  end

  desc "Restart rack server"
  task :restart do 
    Server.check(verbose:false)
    sh Server.restart
  end

  desc "Stop rack server"
  task :stop do 
    Server.check(verbose:false)
    sh Server.stop
  end

  desc "Show rack server pid"
  task :pid do 
    sh "ps ax | grep BOTServer" 
  end

  desc "Tail -f rack sever logfile: #{Config.home_directory}/log/thin.log"
  task :log do
    sh "tail -f log/thin.log" 
  end
end

# aliases 
#task :server => 'server:show'
#task :token => 'tokens:show'
#task :tokens => 'tokens:show'
