require 'colorize' 
require 'telegram/bot'
require 'awesome_print'
require 'yaml'
require_relative 'utilities'
require_relative 'config'

module Tokens
  include Config

  # 
  # given a token, retrieve bot "username" asking to telegram server
  #
  def self.find_bot_name(token)
    status = verify_token(Telegram::Bot::Client.new(token))

    if status['valid_token'] 
      puts "Valid token! Telegram.org Bot name: @#{status['telegram_name']}".green
    else
      $stderr.puts "Not Valid token. #{sanitize(status['telegram_error'])}".red
      exit
    end
    status['telegram_name']
  end  

  #
  # check tokens listed in tokens.yml
  # asking Telegram server 
  # and updating tokens.yml with retrieved info
  #
  def self.check
    config_filename = Config.tokens_config_file
    
    # load bots configuration from YAML file 
    bots_config = YAML.load(File.open(config_filename))

    bots_config.each do | hash |
      token = hash.fetch('token')
    
      puts "\nverifying token: #{token}"
    
      status = verify_token(Telegram::Bot::Client.new(token))
      hash.merge! status
      #ap hash
    
      if status['valid_token'] 
        puts "Valid token! Telegram.org Bot name: @#{status['telegram_name']}".green
      else
        $stderr.puts "Not Valid token. #{sanitize(status['telegram_error'])}".red
      end
    end  
    
    # pretty print the array to save
    s = yaml_dump(bots_config)

    # Save updated configuration in .yml file
    File.open(config_filename, "w") { |f| f.write(s) }
    puts "\nupdated config file: #{config_filename}\n".yellow
  end


  def self.show
    "cat #{Config.tokens_config_file}"
  end

  # 
  # select_valid_tokens
  #
  # scan the bot config file
  # extracting bots entry with a valid token
  #
  # return an array of bot names
  # 
  def self.select_valid_tokens(config_filename)
    # load bots configuration from YAML file
    bots_config = YAML.load(File.open(config_filename))

    bots = []

    bots_config.each do | hash |
      token = hash['token']

      status = verify_token(Telegram::Bot::Client.new(token))
      
      # add to list: name,token pair
      bots << {name: status['telegram_name'], token: token} if status['valid_token']
    end
    bots
  end

  private

  # better than YAML.dump
  def self.yaml_dump(bots_config_hash)
    yaml = "\n"
    bots_config_hash.each do | hash |
      yaml << "- "
      hash.each_pair do |key, value| 
        yaml << "#{key}: #{value}\n  "
      end
      yaml << "\n"
    end
    yaml
  end

  # put a new line before each hash
  def self.yaml_pretty(data)
    YAML.dump(data).gsub("\n-", "\n\n-")
  end

  def self.sanitize(string)
    string.gsub("\\n", '').gsub("\"",'')
  end

  #
  # validate the token and get Bot name, description, 
  # querying Telegram server
  # token example: '123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11'
  #
  def self.verify_token(bot)
    status = {}

    begin
    # call getMe Telegram Bot API endpoint 
    result = bot.api.get_me.fetch('result')

    rescue Exception => e  
      status['valid_token'] = false 
      status['telegram_error'] = "\"#{sanitize(e.message)}\""
      #backtrace: e.backtrace.inspect
    else
      # username is the @BOTNAMEbot 
      # first_name is the public descritpion name (may contain blanks), e.g. "BOT NAME"   
      # id is the  internal Telegram ID for the Bot
      status['telegram_name'] = result['username'] 
      status['telegram_description'] = result['first_name']
      status['telegram_id'] = result['id']
      status['valid_token'] = true 
    end
    status['updated_at'] = time_now 
    status
  end
end
