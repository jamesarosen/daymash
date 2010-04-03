module DayMash
  config_path = File.join(File.dirname(__FILE__), '..', 'api_keys.yml')
  API_KEYS = if File.exist?(config_path)
    YAML.load File.new(config_path)
  else
    {}
  end.with_indifferent_access
end

if defined?(:RPXNow)
  RPXNow.api_key = ENV['RPX_API_KEY'] || DayMash::API_KEYS[:rpx]
end

amazon_config = (DayMash::API_KEYS['amazon'] || {})['s3'] || {}
ENV['AMAZON_ACCESS_KEY_ID'] = amazon_config['access_key_id']
ENV['AMAZON_SECRET_ACCESS_KEY'] = amazon_config['secret_access_key']
