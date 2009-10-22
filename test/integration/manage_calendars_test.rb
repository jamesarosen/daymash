require 'test_helper'

class ManageCalendarsTest < ActionController::IntegrationTest

  include AuthenticationMacros
  
  context 'a signed-in user' do
    
    setup do
      @user = Factory(:user, :display_name => 'Shania Roberts')
      sign_in_as @user
    end
    
    should 'be able view a list of her calendars' do
      visit '/'
      click_link 'My Calendars'
      assert_select '#main', 'My Calendars'
    end
    
  end
  
end
