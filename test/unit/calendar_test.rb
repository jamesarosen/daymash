require 'test_helper'

class CalendarTest < ActiveSupport::TestCase
  
  context 'a Calendar' do
    subject { @calendar }
    setup do
      @user = Factory(:user)
      @other_calendar = Factory(:calendar)
      @calendar = Calendar.new
    end
    should_validate_presence_of :uri, :title, :message => /.+/
    should_validate_uniqueness_of :uri, :title, :scoped_to => :user_id
    should_not_allow_values_for :uri, nil, '', 'a'
    should_allow_values_for :uri, 'http://foo.bar', 'https://baz.yoo/hoo.ics'
  end
  
  context 'a deleted Calendar' do
    setup do
      @user = Factory(:user)
      @calendar = Factory(:calendar, :user => @user)
      assert @calendar.present?
      @calendar.destroy
      assert @user.calendars(true).empty?
    end
    should "be un-deletable" do
      Calendar::Archive.find_by_user_and_id!(@user, @calendar.id).restore
      assert_equal 1, @user.calendars(true).size
    end
  end
    
end
