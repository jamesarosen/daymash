ENV["RAILS_ENV"] = "test"

require 'rubygems'
gem 'jferris-mocha'
$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

require 'mocha'
require 'shoulda'
require 'factory_girl'
require 'webrat'
require 'timecop'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

TwitterHelper.class_eval do
  def recent_tweets
    []
  end
end

ActionController::TestCase.class_eval do
  def setup
    super
    @controller.session ||= HashWithIndifferentAccess.new
  end
  
  def teardown
    Mocha::Mockery.instance.teardown
    [Calendar, Credential, User].each { |mc| mc.delete_all }
    super
  end
  
  def rpx_returns(hash)
    FakeWeb.allow_net_connect = false
    json_response = { :profile => hash }.to_json
    FakeWeb.register_uri :post, %r|^https://rpxnow.com/api/v2/auth_info|,
                                :body => json_response
  end
end

# ActionController::IntegrationTest.class_eval do
#   def setup
#     reset!
#   end
# end
# 
# Webrat.configure do |config|
#   config.mode = :rails
# end
