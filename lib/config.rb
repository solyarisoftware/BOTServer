module Config
  #
  # project home directory (where you run rake *)
  #
  def self.home_directory
    File.expand_path('..', File.dirname(__FILE__))
  end

  #
  # directory containing apps, generated with rake app:new
  #
  def self.app_directory
    File.expand_path('../app', File.dirname(__FILE__))
  end
 
  #
  # directory containing certificate keys, generated with rake certificate:new
  #
  def self.ssl_directory
    File.expand_path('../ssl', File.dirname(__FILE__))
  end
  
  #
  # directory containing templates
  #
  def self.templates_directory
    File.expand_path('../templates', File.dirname(__FILE__))
  end
 
  #
  # path name for tokens congiguration file
  #
  def self.tokens_config_file
    File.expand_path('../config/tokens.yml', File.dirname(__FILE__))
  end

  #
  # path name for server congiguration file
  #
  def self.server_config_file
    File.expand_path('../config/server.yml', File.dirname(__FILE__))
  end
end 
