require 'test_helper'

class UserTest < ActiveSupport::TestCase

  context 'a User' do
    subject { @user }
    setup do
      @other_user = Factory(:user)
      @user = User.new
    end
    should_validate_presence_of :username, :email, :message => /.+/
    should_validate_uniqueness_of :username, :email
    should_not_allow_values_for :password, nil, '', 'a', 'ab', 'abc'
  end
  
  context 'a User with a display_name' do
    setup { @user = Factory(:user, :display_name => 'Fred Cartwright') }
    should 'use the display name for :to_s' do
      assert_equal 'Fred Cartwright', @user.to_s
    end
  end
  
  context 'a User without a display_name, but with a username' do
    setup { @user = Factory(:user, :username => 'fred12', :display_name => nil) }
    should 'use the display name for :to_s' do
      assert_equal 'fred12', @user.to_s
    end
  end
    
end
