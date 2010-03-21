config_path = File.join(File.dirname(__FILE__), '..', 'api_keys.yml')
api_keys = if File.exist?(config_path)
  YAML.load File.new(config_path)
else
  {}
end.with_indifferent_access

if defined?(:RPXNow)
  RPXNow.api_key = ENV['RPX_API_KEY'] || api_keys[:rpx]
end
