require 'test_helper'

class SignUpTest < ActionController::IntegrationTest
  
  include AuthenticationMacros
  
  setup :activate_authlogic

  context 'a returning signed-out user' do
    
    setup do
      @user = Factory(:user, :password => 'umlaut')
      sign_out!
    end
    
    should 'be able to sign in with a username' do
      visit '/'
      click_link 'Sign In'
      fill_in 'Username', :with => @user.username
      fill_in 'Password', :with => 'umlaut'
      click_button "I'm Pumped. Schedulify me!"
      assert_equal @user, controller.send(:current_user)
    end
    
  end
  
end
