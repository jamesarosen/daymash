config.cache_classes = true

config.whiny_nils = true

config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

config.action_controller.allow_forgery_protection    = false
  
config.action_mailer.delivery_method = :test

config.gem 'mocha',         :version => '~> 0.9.8',   :source => 'http://rubygems.org/'
config.gem 'shoulda',       :version => '~> 2.10.3',  :source => 'http://rubygems.org/'
config.gem 'factory_girl',  :version => '~> 1.2.3',   :source => 'http://rubygems.org/'
config.gem 'redgreen',      :version => '~> 1.2.2',   :source => 'http://rubygems.org/'
config.gem 'fakeweb',       :version => '~> 1.2.8',   :source => 'http://rubygems.org/'
config.gem 'timecop',       :version => '~> 0.2.1',   :source => 'http://rubygems.org/'