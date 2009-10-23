require 'test_helper'
require 'fix_ri_cal_period'
require 'ri_cal/core_extensions/range'

class UsersControllerTest < ActionController::TestCase

  def setup
    @laila = Factory(:user, :display_name => 'Laila Z. Ziggy')
  end

  context 'a signed-out visitor trying to edit a profile' do
    setup { get :edit, :id => @laila.to_param }
    should_respond_with :unauthorized
  end
  
  context 'a signed-out visitor trying to update a profile' do
    setup { put :update, :id => @laila.to_param, :user => { :useranme => 'hacked' } }
    should_respond_with :unauthorized
  end
  
  context "a signed-out visitor retrieving a User's free-busy feed" do
    
    setup do
      @coffee_date = ((30.minutes.from_now)..(1.hour.from_now))
      @vacation    = ((2.days.from_now)..(2.weeks.from_now))
      freebusy = RiCal.Calendar do |cal|
        cal.freebusy do |fb_block|
          fb_block.add_freebusy @coffee_date
          fb_block.add_freebusy @vacation
        end
      end
      User.stubs(:find).returns(@laila)
      @laila.stubs(:aggregate_freebusy_calendar).returns(freebusy)
      get :busy, :id => @laila.to_param
    end
    
    should_respond_with :success
    
    should_respond_with_content_type :ics
    
    should "look up the User's freebusy aggregate" do
      assert_received(@laila, :aggregate_freebusy_calendar)
    end
    
  end

end
