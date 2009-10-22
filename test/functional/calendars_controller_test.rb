require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase

  def setup
    @clarence = Factory(:user, :display_name => 'Clarence Biggs')
  end

  context "a signed-out visitor trying to view a User's list of Calendars" do
    setup { get :index, :user_id => @clarence.to_param }
    should_respond_with :unauthorized
    should_not_assign_to :user
    should_not_assign_to :calendars
  end

end
