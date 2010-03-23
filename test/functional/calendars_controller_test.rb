require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase

  def setup
    super
    @clarence = Factory(:user, :display_name => 'Clarence Biggs')
    @soccer = Factory(:calendar, :user => @clarence, :title => 'Soccer')
  end

  context "a signed-out visitor trying to view a User's list of Calendars" do
    setup { get :index, :user_id => @clarence.to_param }
    should_respond_with :unauthorized
    should_not_assign_to :user
    should_not_assign_to :calendars
  end
  
  context 'a signed-in user' do
    setup { @controller.stubs(:current_user).returns(@clarence) }
    
    context 'deleting a calendar' do
      setup { delete :destroy, :user_id => :current, :id => @soccer.to_param }
      should_redirect_to("the user's aggregate page") { user_aggregate_path(:current) }
      should_change("the number of the user's calendars", :by => -1) { @clarence.calendars(true).count }
      should "store the deleted credential's ID in the session for undo purposes" do
        assert_equal @soccer.id, @controller.session[AdvancedFlash::DELETED_CALENDAR_SESSION_ID]
      end
      should_set_the_flash_to AdvancedFlash::DELETED_CALENDAR_FLASH
    end
    
    context 'deleting a calendar via AJAX' do
      setup { xhr :delete, :destroy, :user_id => :current, :id => @soccer.to_param }
      should_render_template :destroy
      should_change("the number of the user's calendars", :by => -1) { @clarence.calendars(true).count }
      should "remove the relevant DOM element" do
        assert_match /DayMash\.deleteCalendar\('#{@soccer.to_param}'\);/, @response.body
      end
    end
    
    context 'with a deleted calendar' do
      setup { @soccer.destroy }
      
      context "un-deleting that calendar" do
        setup { put :undestroy, :user_id => :current, :id => @soccer.to_param }
        should_redirect_to("the user's aggregate page") { user_aggregate_path(:current) }
        should_change("the number of the user's calendars", :by => 1) { @clarence.calendars(true).count }
      end
      
      context 'undeleting that calendar via AJAX' do
        setup { xhr :put, :undestroy, :user_id => :current, :id => @soccer.to_param }
        should_render_template :undestroy
        should_change("the number of the user's calendars", :by => 1) { @clarence.calendars(true).count }
        should "insert the new Calendar in the DOM" do
          assert_match /DayMash\.insertCalendar\(/, @response.body
        end
      end
    end
    
  end

end
