module Certificate
  # See webhooks API docs: 
  # Upload your optional public key certificate so that the root certificate in use can be checked. 
  # See self-signed guide for details
  # https://core.telegram.org/bots/api#setwebhook
  # https://core.telegram.org/bots/self-signed
  # YOURPUBLIC.pem has to be used as input for setting the self-signed webhook.

  def self.create_pair_command(file_name_key, file_name_pem, host)
    File.read("#{Config.templates_directory}/certificate_new.sh.template") % 
      { 
        :file_name_key => file_name_key, 
        :file_name_pem => file_name_pem, 
        #
        # sets certificate subject
        #
        # /C=   Country  
        # /ST=  State   
        # /L=   Location 
        # /O=   Organization 
        # /OU=  Organizational Unit
        #
        # IMPORTANT:
        # ##########
        # /CN=  Common Name   hostname.com
        #
        :C => "IT",
        :ST => "state",
        :L => "location",
        :O => "description",
        :host => host
      }
  end

  # inspect the generated certificate
  def self.show_command(file_name_pem)
    File.read("#{Config.templates_directory}/certificate_show.sh.template") % 
      { :file_name_pem => file_name_pem }

  end
end
