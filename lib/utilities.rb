#
# file: utilities.rb
#
require 'time'

# return timestamp in ISO8601 with precision in milliseconds 
def time_now
  #Time.now.utc.iso8601(3)
  Time.now.utc.iso8601
end

def remove_tilde(string)
  string.tr('@', '')
end

def underscore(string)
   string.gsub(/::/, '/').
   gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
   gsub(/([a-z\d])([A-Z])/,'\1_\2').
   tr("-", "_").
   downcase
end

def underscored_filename(string, path='.')
  "#{path}/#{underscore(string)}.rb"
end

def downcase_filename(string, path='.')
  "#{path}/#{string.downcase}.rb"
end

def camelize(string)
  words = string.split('_')
  words.drop(1).map(&:capitalize!)
  words.join
end

def camelize_as_class(string)
  camelized = camelize(string)
  camelized[0] = camelized[0].upcase
  camelized
end
