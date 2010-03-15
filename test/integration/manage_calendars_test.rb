require 'test_helper'

class ManageCalendarsTest < ActionController::IntegrationTest

  def html
    body = @response.body
    body = body.join("\n") if body.kind_of?(Array)
    puts body.gsub("\n", "\n ")
  end
  
  include AuthenticationMacros
  
  context 'a signed-in user with calendars' do
    
    setup do
      @user = Factory(:user, :display_name => 'Shania Roberts')
      Factory(:calendar, :user => @user)
      sign_in_as @user
      assert controller.signed_in?
      puts "session in setup: #{controller.session.inspect} (#{controller.session.object_id})"
    end
    
    should 'be able view a list of her calendars' do
      visit '/'
      puts "session in should: #{controller.session.inspect} (#{controller.session.object_id})"
      assert controller.signed_in?
      puts html
      click_link 'My Calendars'
      assert_select '#main' do
        assert_select 'h2', 'My Calendars'
        @user.calendars.each do |calendar|
          assert_select "a[href=#{calendar.uri}]", calendar.title
        end
      end
    end
    
    # should 'be able to add a calendar' do
    #   visit '/'
    #   click_link 'My Calendars'
    #   click_link 'Add Calendar'
    #   fill_in 'URL', :with => 'http://cupcakeheaven.com/events.ics'
    #   fill_in 'Title', :with => 'Cupcake Heaven Events'
    #   click_button 'Feed Me'
    #   assert_select '#main' do
    #     assert_select 'a[href=http://cupcakeheaven.com/events.ics]', 'Cupcake Heaven Events'
    #   end
    # end
    
  end
  
end
