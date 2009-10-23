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
    
    should 'be able to add a calendar' do
      visit '/'
      click_link 'My Calendars'
      click_link 'Add Calendar'
      fill_in 'URL', :with => 'http://cupcakeheaven.com/events.ics'
      fill_in 'Title', :with => 'Cupcake Heaven Events'
      click_button 'Feed Me'
      assert_select '#main' do
        assert_select 'a[href=http://cupcakeheaven.com/events.ics]', 'Cupcake Heaven Events'
      end
    end
    
  end
  
end
