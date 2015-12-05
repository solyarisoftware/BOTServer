require_relative 'config'

module Proxy
  include Config

  def self.start
    shell_command :start
  end

  def self.restart
    shell_command :restart
  end

  def self.stop
    shell_command :stop
  end
  #
  # HTTPS configuration for nginx config
  #  
  def self.config
    File.read("#{Config.templates_directory}/proxy_config.template") % 
      { 
        :port => self.port, 
        :host => self.host, 
        :certificate_file_pem => self.certificate_file_pem, 
        :certificate_file_key => self.certificate_file_key
      }
  end

  private

  def self.shell_command(action)
    File.read("#{Config.templates_directory}/proxy.sh.template") % { :action => action }
  end  

end
