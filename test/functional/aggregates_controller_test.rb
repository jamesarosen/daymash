require 'test_helper'
require 'free_busy_aggregate'

class AggregatesControllerTest < ActionController::TestCase
  
  def setup
    super
    @cassandra = Factory(:user, :display_name => 'Cassandra')
    Factory(:calendar, :user => @cassandra)
  end
  
  context 'a signed-out visitor' do
    context "trying to view information about a user's aggregate" do
      setup { get :show, :user_id => @cassandra }
      should_respond_with :unauthorized
    end
    
    context "retrieving a User's free-busy feed" do
    
      setup do
        @coffee_date = ((30.minutes.from_now)..(1.hour.from_now))
        @vacation    = ((2.days.from_now)..(2.weeks.from_now))
        freebusy = RiCal.Calendar do |cal|
          [@coffee_date, @vacation].each do |event|
            cal.event do |e|
              e.description = 'Busy'
              e.dtstart = event.begin
              e.dtend = event.end
            end
          end
        end
        User.stubs(:find).returns(@cassandra)
        @cassandra.stubs(:aggregate_freebusy_calendar).returns(freebusy)
      end
      
      context "without the User's privacy token" do
        setup do
          get :show, :user_id => @cassandra.to_param, :format => 'ics', :pt => 'anything'
        end
        should_respond_with :unauthorized
      end
      
      context "with the User's privacy token" do
        setup do
          get :show, :user_id => @cassandra.to_param, :format => 'ics', :pt => @cassandra.privacy_token
        end
    
        should_respond_with :success
        should_assign_to(:user) { @cassandra }
        should_respond_with_content_type :ics
        should "look up the User's freebusy aggregate" do
          assert_received(@cassandra, :aggregate_freebusy_calendar)
        end
      end
    
    end
  end

  context 'a signed-in user' do
    
    setup { @controller.stubs(:current_user).returns(@cassandra) }
    
    context 'viewing information about her aggregate' do
      setup { get :show, :user_id => @cassandra }
      should_assign_to(:user) { @cassandra }
      should_render_template :show
      should_respond_with :success
    end
    
    context 'resetting her privacy token' do
      setup { put :reset_privacy_token, :user_id => @cassandra }
      should_redirect_to("the aggregate page") { user_aggregate_path(:user_id => @cassandra) }
      should_change("the user's privacy token") { @cassandra.reload; @cassandra.privacy_token }
      should_set_the_flash_to(/reset|success/i)
    end
    
    context 'resetting her privacy token by XHR (AJAX)' do
      setup { xhr :put, :reset_privacy_token, :user_id => @cassandra }
      should_render_template :reset_privacy_token
      should_change("the user's privacy token") { @cassandra.reload; @cassandra.privacy_token }
      should "highlight the aggregate URL" do
        assert_match /DayMash\.updateAggregateUrl\(.*<a.*\);/, @response.body
      end
    end
    
  end
  
end
