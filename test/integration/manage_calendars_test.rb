require 'test_helper'

class ManageCalendarsTest < ActionController::IntegrationTest

  include AuthenticationMacros
  
  context 'a signed-in user with calendars' do
    
    setup do
      @user = Factory(:user, :display_name => 'Shania Roberts')
      Factory(:calendar, :user => @user)
      sign_in_as @user
    end
    
    should 'be able view a list of her calendars' do
      visit '/'
      click_link 'My Calendars'
      assert_select '#main' do
        assert_select 'h2', 'My Calendars'
        @user.calendars.each do |calendar|
          assert_select "a[href=#{calendar.uri}]", calendar.title
        end
      end
    end
    
  end
  
end
