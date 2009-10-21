require 'test_helper'

class SignUpTest < ActionController::IntegrationTest
  
  include AuthenticationMacros
  
  def setup
    visit '/'
  end
  
  context 'a returning signed-out user' do
    
    setup do
      @user = Factory(:user, :password => 'umlaut')
      sign_out!
    end
    
    should 'be able to sign in with a username and password' do
      visit '/'
      click_link 'Sign In'
      fill_in 'Username', :with => @user.username
      fill_in 'Password', :with => 'umlaut'
      click_button "I'm Pumped. Schedulify me!"
      assert_select '#navbar', /Signed in as/
      assert_equal @user, controller.send(:current_user)
    end
    
  end
  
  context 'a signed-in user' do
    
    setup do
      @user = Factory(:user, :display_name => 'Fred Cologne')
      sign_in_as @user
    end
    
    # TODO: figure out why Webrat sessions are
    #       dying between requests here
    should_eventually 'be able to sign out' do
      visit '/'
      click_link 'Sign Out'
      assert_select '#navbar', /Sign In/
    end
    
  end
  
end
