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
    
end
