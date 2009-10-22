require 'test_helper'
require 'authlogic/test_case'

class UserProfileTest < ActionController::IntegrationTest
  
  include Authlogic::TestCase
  include AuthenticationMacros
  
  def setup
    activate_authlogic
  end

  context 'signed-in user' do
    
    setup do
      @user = Factory(:user, :display_name => 'Stephanie Calloway')
      sign_in_as @user
    end
    
    should 'be able to change her username' do
      visit '/'
      click_link 'Edit Profile'
      fill_in 'Username', :with => 'stephc'
      click_button 'Make It So'
      assert_equal 'stephc', @user.reload.username
    end
    
  end
  
end
