require 'telegram/bot'
require 'colorize' 
require 'awesome_print'
require 'multi_json'

module Webhook

  def self.set(token, certificate_file)
    webhook(:set, token, certificate_file)
  end

  def self.reset(token, certificate_file)
    webhook(:reset, token, certificate_file)
  end

  private
  # 
  # to set webhook   ->  action = :set 
  # to unset webhook -> action = :reset
  #
  def self.webhook(action, token, certificate_file)
    fail "action #{action} not allowed" unless [:set, :reset].include? action

    url = Server.url(token)

    puts "\n#{(action == :set)? '' : 're'}setting webhook: #{url}"

    # create bot from given token
    client = Telegram::Bot::Client.new(token)

    # what action: :set or :unset ?
    url_webhook = (action == :set)? url : ''

    # telegram server feedbacks exception handler
    begin
    #
    # WARNING 
    # Note that setWebhook action by the bot instance (settings.bot) that OWN the token (#singleBotManagement)
    # This means that to manage multiple bots, this app would manage and array of bot (#multipleBotManagement)
    #
    if certificate_file.nil?
      puts "no certificate file?".yellow
      certificate = nil
    else
      puts "certificate file: #{certificate_file}".yellow
      certificate = Faraday::UploadIO.new(File.expand_path(certificate_file), 'application/x-pem-file')
    end  
    resp = client.api.set_webhook(url: url_webhook, certificate: certificate)

    rescue Exception => e  
      # error
      $stderr.puts "ERROR. Telegram Server refuse request for token: #{token}".red
      $stderr.puts "reason: #{e.message}".red #e.backtrace.inspect
      exit 
    else
      # success
      puts "ok: #{resp['ok']}, result: #{resp['result']}, description: #{resp['description']}".yellow
      set_message = "URL: #{url_webhook}".green
      unset_message = "get updates with a long polling connection, now.".green
      puts "#{(action == :reset) ? unset_message : set_message}"
    end
  end
end 
