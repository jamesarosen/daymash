require 'test_helper'

class SignUpTest < ActionController::IntegrationTest
  
  include AuthenticationMacros

  context 'a signed-out visitor' do
    
    setup do
      visit '/'
      sign_out!
    end
    
    should 'be able to register' do
      # how to test this?
    end
    
  end
  
end
