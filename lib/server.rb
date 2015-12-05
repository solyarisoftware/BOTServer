require 'colorize'
require 'awesome_print'
require 'yaml'
require_relative 'config'

module Server
  include Config

  @@tag = 'BOTServer'

  #
  # load server configuration from YAML file 
  #
  def self.check(verbose: true)
    config_filename = Config.server_config_file

    config = YAML.load(File.open(config_filename))

    @@host = validates_host(config['host'], verbose: verbose)
    @@port = validates_port(config['port'], verbose: verbose)

    @@certificate_file_key = config['certificate_file_key']
    @@certificate_file_pem = config['certificate_file_pem']
    
    # check existence of certificate files
    validates_certificate(@@certificate_file_key, verbose: verbose)
    validates_certificate(@@certificate_file_pem, verbose: verbose)

    puts "webhooks urls format: #{url('token')}".yellow if verbose
    self
  end

  #
  # getters of module (=class) variables
  #
  def self.host
    @@host
  end  

  def self.port
    @@port
  end  

  def self.certificate_file_pem
    File.expand_path(@@certificate_file_pem) # file name, string
  end

  def self.certificate_file_key
    File.expand_path(@@certificate_file_key) # file name, string
  end

  def self.show
    "cat #{Config.server_config_file}"
  end

  def self.start
    shell_command(:start, @@host, @@port, certificate_file_key, certificate_file_pem)
  end

  def self.restart
    shell_command(:restart, @@host, @@port, certificate_file_key, certificate_file_pem)
  end

  def self.stop
    shell_command(:stop, @@host, @@port, certificate_file_key, certificate_file_pem)
  end

  # 
  # Webhook URL format: https://yourhost:yourport/token
  #
  def self.url(token) 
    port = (@@port == 80) ? '' : ":#{@@port}"
    "https://#{@@host}#{port}/#{token}"
  end

  private

  # 
  # thin rack server command line
  #
  def self.shell_command(action, host, port, file_name_key, file_name_pem)
    # https://github.com/macournoyer/thin/
    #  WARNING:
    #  log tokens in log file could be bad idea for security reasons.
    #  -l #{Config.home_directory}/logs/thin.log\
    # --ssl \
    # --ssl-key-file #{file_name_key} \
    # --ssl-cert-file #{file_name_pem} \
    File.read("#{Config.templates_directory}/thin.sh.template") % 
      { 
        :action => action, 
        :rackup => "#{Config.home_directory}/rackup/router.ru", 
        :tag => @@tag,
        :pid => "#{Config.home_directory}/tmp/pids/thin.pid"
      }
  end  

  #
  # validation methods
  #
  def self.validates_host(host, verbose:true)
    if host.nil?
      $stderr.puts "ERROR. host variable unset." 
      exit 
    end

    puts "valid host: #{host}".green if verbose
    host
  end

  def self.validates_port(port, verbose:true)
    if port.nil?
      $stderr.puts "ERROR. PORT variable unset." 
      exit
    end

    # Ports currently supported for Telegram Webhooks: 443, 80, 88, 8443
    unless [443, 80, 88, 8443].include? port
      $stderr.puts "ERROR. PORT invalid." 
      exit
    end  

    puts "valid port: #{port}".green if verbose
    port
  end  

  # 
  # Certificate File
  #
  # See webhooks API docs: 
  # Upload your optional public key certificate so that the root certificate in use can be checked. 
  # See self-signed guide for details
  # https://core.telegram.org/bots/api#setwebhook
  # https://core.telegram.org/bots/self-signed
  #
  def self.validates_certificate(certificate_file_name, verbose: true)
    if certificate_file_name.nil?
      $stderr.puts "ERROR. #{certificate_file_name} certificate variable unset.".red
      exit
    end  

    # get file handler
    certificate_file = File.open(File.expand_path(certificate_file_name))
    
    if certificate_file.nil?
      $stderr.puts "ERROR. certificate file: #{certificate_file_name} not found.".red
      exit
    end  

    puts "valid certificate file: #{certificate_file_name}".green if verbose

    certificate_file
  end  
end  
