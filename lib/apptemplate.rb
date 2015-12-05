require_relative 'utilities'

module AppTemplate

  def self.build_app(bot_name, token, path)

    template = File.read("#{Config.templates_directory}/app.rb.template") % 
      { 
        :file_name => "#{bot_name.downcase}.rb",
        :class_name => camelize_as_class(bot_name), 
        :token => token
      }

      file_path = "#{path}/#{bot_name.downcase}.rb"   
    File.write(file_path, template)
    puts "created template app: #{file_path}".yellow
  end

end
