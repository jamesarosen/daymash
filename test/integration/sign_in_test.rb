require 'test_helper'

class SignUpTest < ActionController::IntegrationTest
  
  include AuthenticationMacros
  
  def setup
    visit '/'
  end
  
  context 'a returning signed-out user' do
    
    setup do
      @user = Factory(:user)
      sign_out!
    end
    
    should 'be able to sign in via Twitter' do
      # how to test this?
    end
    
    should 'be able to sign in via Facebook' do
      # how to test this?
    end
    
  end
  
  context 'a signed-in user' do
    
    setup do
      @user = Factory(:user, :display_name => 'Fred Cologne')
      sign_in_as @user
    end
    
    should 'be able to sign out' do
      visit '/'
      click_link 'Sign Out'
      assert_select 'header', /Sign In/
    end
    
  end
  
end
