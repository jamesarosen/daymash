config.cache_classes = true

config.whiny_nils = true

config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

config.action_controller.allow_forgery_protection    = false

config.action_mailer.delivery_method = :test

config.gem "thoughtbot-shoulda", :lib => "shoulda",
                                 :source => "http://gems.github.com",
                                 :version => "2.10.2"
                                 
config.gem "thoughtbot-factory_girl", :lib => "factory_girl",
                                      :source => "http://gems.github.com", 
                                      :version => "1.2.1"
                                      
config.gem 'jferris-mocha', :source => 'http://gems.github.com',
                            :lib => 'mocha',
                            :version => '>= 0.9.7'
                            
config.gem 'redgreen', :lib => 'redgreen',
                       :version => '1.2.2'

config.gem 'webrat', :version => '0.4.4'

config.gem 'fakeweb', :version => '1.2.5'
