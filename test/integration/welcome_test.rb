require 'test_helper'

class WelcomeTest < ActionController::IntegrationTest
  
  extend PerformanceMacros
  
  context 'a GET to / while signed out' do
    
    setup { get('/') }
      
    should_respond_with :success
    
    should 'be welcoming' do
      assert_select 'body', /\b(welcome|h[eu]llo|hi|wilkommen)\b/i
    end
    
    should 'allow users to sign up' do
      assert_select 'a', /sign up/i
    end
    
    should 'allow users to sign in' do
      assert_select 'a', /sign in/i
    end
    
    should_take_on_average_less_than 0.3.seconds do
      get '/'
    end
    
  end
  
end
