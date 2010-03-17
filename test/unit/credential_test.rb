require 'test_helper'

class CredentialTest < ActiveSupport::TestCase
  
  context 'The Credential class' do
    setup do
      @user = Factory(:user)
      @credential = Factory(:credential, :user => @user)
    end
    should 'find Credentials by provider and identifier' do
      assert_equal @credential, Credential.find_by_provider_and_identifier(@credential.provider, @credential.identifier)
    end
  end

  context 'a Credential' do
    setup do
      @user = Factory(:user)
      @credential = Factory(:credential, :user => @user)
    end
    
    subject { @credential }
    
    should_validate_presence_of :provider
    should_allow_values_for :provider, 'Twitter', 'MyOpenID', 'Facebook'
    should_validate_presence_of :identifier
    should_allow_values_for :identifier, 'http://twitter.com/me', 'https://me.myopenid.com'
  end
  
  context 'a deleted Credential' do
    setup do
      @user = Factory(:user)
      @credential = @user.credentials.first
      assert @credential.present?
      @credential.destroy
      assert @user.credentials(true).empty?
    end
    should "be un-deletable" do
      Credential::Archive.find_by_user_and_id!(@user, @credential.id).restore
      assert_equal 1, @user.credentials(true).size
    end
  end
    
end

