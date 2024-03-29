require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase

  def setup
    super
    Timecop.travel(1.week.ago) do
      @clarence = Factory(:user, :display_name => 'Clarence Biggs')
      @soccer = Factory(:calendar, :user => @clarence, :title => 'Soccer')
    end
  end

  context "a signed-out visitor" do
    
    context "trying to view a User's list of Calendars" do
      setup { get :index, :user_id => @clarence.to_param }
      should_respond_with :unauthorized
      should_not_assign_to :user
      should_not_assign_to :calendars
    end
    
    context "trying to add a Calendar to a User's account" do
      setup { post :create, :user_id => @clarence.to_param, :calendar => Factory.attributes_for(:calendar) }
      should_respond_with :unauthorized
      should_not_assign_to :user
      should_not_assign_to :calendars
      should_not_change("the number of the User's Calendars") { @clarence.calendars(true).count }
    end
    
    context "trying to delete a Calendar from a User's account" do
      setup { delete :destroy, :user_id => @clarence.to_param, :id => @soccer.to_param }
      should_respond_with :unauthorized
      should_not_assign_to :user
      should_not_assign_to :calendars
      should_not_change("the number of the User's Calendars") { @clarence.calendars(true).count }
    end
    
  end
  
  context 'a signed-in user' do
    setup { @controller.stubs(:current_user).returns(@clarence) }
    
    context 'adding a calendar' do
      setup { post :create, :user_id => @clarence, :calendar => Factory.attributes_for(:calendar) }
      should_redirect_to("the user's aggregate page") { user_aggregate_path(@clarence) }
      should_change("the number of the user's calendars", :by => 1) { @clarence.calendars(true).count }
      should 'create a valid calendar' do
        assert assigns(:calendar).errors.blank?, assigns(:calendar).errors.inspect
      end
      should_change("the User's ETag") { @clarence.reload.updated_at }
    end
    
    context 'deleting a calendar' do
      setup { delete :destroy, :user_id => @clarence, :id => @soccer.to_param }
      should_redirect_to("the user's aggregate page") { user_aggregate_path(@clarence) }
      should_change("the number of the user's calendars", :by => -1) { @clarence.calendars(true).count }
      should "store the deleted credential's ID in the session for undo purposes" do
        assert_equal @soccer.id, @controller.session[AdvancedFlash::DELETED_CALENDAR_SESSION_ID]
      end
      should_set_the_flash_to AdvancedFlash::DELETED_CALENDAR_FLASH
      should_change("the User's ETag") { @clarence.reload.updated_at }
    end
    
    context 'deleting a calendar via AJAX' do
      setup { xhr :delete, :destroy, :user_id => @clarence, :id => @soccer.to_param }
      should_render_template :destroy
      should_change("the number of the user's calendars", :by => -1) { @clarence.calendars(true).count }
      should "remove the relevant DOM element" do
        assert_match /DayMash\.deleteCalendar\('#{@soccer.to_param}'\);/, @response.body
      end
      should_change("the User's ETag") { @clarence.reload.updated_at }
    end
    
    context 'with a deleted calendar' do
      setup { Timecop.travel(5.days.ago) { @soccer.destroy } }
      
      context "un-deleting that calendar" do
        setup { put :undestroy, :user_id => @clarence, :id => @soccer.to_param }
        should_redirect_to("the user's aggregate page") { user_aggregate_path(@clarence) }
        should_change("the number of the user's calendars", :by => 1) { @clarence.calendars(true).count }
        should_change("the User's ETag") { @clarence.reload.updated_at }
      end
      
      context 'undeleting that calendar via AJAX' do
        setup { xhr :put, :undestroy, :user_id => @clarence, :id => @soccer.to_param }
        should_render_template :undestroy
        should_change("the number of the user's calendars", :by => 1) { @clarence.calendars(true).count }
        should "insert the new Calendar in the DOM" do
          assert_match /DayMash\.insertCalendar\(/, @response.body
        end
        should_change("the User's ETag") { @clarence.reload.updated_at }
      end
    end
    
  end

end
