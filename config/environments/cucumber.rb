eval File.read(File.join(File.dirname(__FILE__), 'test.rb'))

config.action_view.cache_template_loading            = false

quick_auth = Class.new do
  def initialize(app); @app = app; end
  def call(env)
    request = ::Rack::Request.new(env)
    if request.params.has_key?('current_user_id')
      request.session[:current_user_id] = request.params['current_user_id']
    end
    @app.call(env)
  end
end
config.middleware.use quick_auth

config.gem "cucumber",       :lib => false, :version => "~> 0.6.3", :source => 'http://rubygems.org/'
config.gem "cucumber-rails", :lib => false, :version => "~> 0.3.0", :source => 'http://rubygems.org/'
config.gem 'webrat',                        :version => '~> 0.7.0', :source => 'http://rubygems.org/'
