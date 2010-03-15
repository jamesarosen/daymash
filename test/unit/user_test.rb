require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  context 'creating a User from RPX' do
    setup do
      Credential.delete_all
      User.delete_all
      @user = User.find_or_initialize_with_rpx({
        :provider => 'OpenID',
        :identifier => 'http://me.example.com',
        :email => 'me@example.com',
        :display_name => 'ME!'
      })
    end
    should 'create a new valid user' do
      assert !@user.new_record?
      assert @user.valid?
    end
    should "import the email address" do
      assert_equal 'me@example.com', @user.email
    end
    should 'import the display name' do
      assert_equal 'ME!', @user.display_name
    end
    should 'create a Credential' do
      assert @user.credentials.any?
      assert_equal 'openid', @user.credentials.first.provider
      assert_equal 'http://me.example.com', @user.credentials.first.identifier
    end
  end
  
  context 'updating a User with new information from RPX' do
    setup do
      Credential.delete_all
      User.delete_all
      @user = Factory(:user, :display_name => nil, :email => 'old.email@example.org')
      credential = @user.credentials.first
      Credential.expects(:find_by_provider_and_identifier).with(credential.provider, credential.identifier).returns(credential)
      User.find_or_initialize_with_rpx({
        :provider => credential.provider,
        :identifier => credential.identifier,
        :display_name => 'Bob',
        :email => 'new.email@example.org'
      })
    end
    should 'not create a new User or Credential' do
      assert_equal [@user], User.all
      assert_equal [@user.credentials.first], Credential.all
    end
    should "import previously blank information" do
      assert_equal 'Bob', @user.reload.display_name
    end
    should 'not overwrite existing information' do
      assert_equal 'old.email@example.org', @user.reload.email
    end
  end

  context 'a User' do
    subject { @user }
    setup do
      @other_user = Factory(:user)
      @user = User.new
    end
    should_allow_values_for :email, 'me@example.com'
    should_not_allow_values_for :email, nil, '', 'a', 'ab'
  end
  
  context 'a User with a display_name' do
    setup { @user = Factory(:user, :display_name => 'Fred Cartwright') }
    should 'use the display name for :to_s' do
      assert_equal 'Fred Cartwright', @user.to_s
    end
  end
  
  context 'a User without a display_name, but with an email address' do
    setup { @user = Factory(:user, :email => 'fred@example.org', :display_name => nil) }
    should 'use the OpenID URL for :to_s' do
      assert_equal 'fred@example.org', @user.to_s
    end
  end
  
  context 'with Credentials' do
    setup do
      @user = Factory(:user)
      Factory(:credential, :user => @user, :provider => 'Twitter')
    end
    should 'know whether it has a Credential from a given provider' do
      assert  @user.has_credential_from?(:twitter)
      assert !@user.has_credential_from?(:golf_channel)
    end
  end
    
end
