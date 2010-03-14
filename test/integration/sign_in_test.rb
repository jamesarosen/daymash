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
      fill_in 'Username or Email Address', :with => @user.username
      fill_in 'Password', :with => 'umlaut'
      click_button "I'm Pumped. Schedulify me!"
      assert_select 'header', /Signed in as/
    end
    
    should 'be able to sign in with an email address and password' do
      visit '/'
      click_link 'Sign In'
      fill_in 'Username or Email Address', :with => @user.email
      fill_in 'Password', :with => 'umlaut'
      click_button "I'm Pumped. Schedulify me!"
      assert_select 'header', /Signed in as/
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
