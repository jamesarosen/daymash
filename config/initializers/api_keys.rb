config_path = File.join(File.dirname(__FILE__), '..', 'api_keys.yml')
api_keys = if File.exist?(config_path)
  YAML.load File.new(config_path)
else
  {}
end

if defined?(:RPXNow)
  RPXNow.api_key = Object.const_defined?(:RPX_API_KEY) ? RPX_API_KEY : api_keys[:rpx]
end
