require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  FACEBOOK_RESPONSE = <<-EOB
{
  "profile": {
    "photo": "http://profile.ak.facebook.com/v279/631/23/n531453_9399.jpg",
    "name": {
      "givenName": "Yags",
      "familyName": "Hound",
      "formatted": "Yags Hound"
    },
    "displayName": "Yags Hound",
    "preferredUsername": "YagsHound",
    "url": "http://www.facebook.com/profile.php?id=713564516",
    "gender": "male",
    "utcOffset": "08:00",
    "birthday": "1982-12-08",
    "email": "yagshound@example.org",
    "providerName": "Facebook",
    "identifier": "http://www.facebook.com/profile.php?id=914164208"
  }
}
EOB

  context 'an existing User with a Facebook account' do
    
    setup do
      @user = Factory(:user)
      @facebook_credential = Factory(:credential, :user => @user, :provider => 'Facebook', :identifier => 'http://www.facebook.com/profile.php?id=914164208')
    end
    
    context 'signing in via Facebook' do
      setup do
        rpx_returns :providerName => 'Facebook', :identifier => 'http://www.facebook.com/profile.php?id=914164208'
        post :create, :token => 'a token'
      end
      should 'sign the User in' do
        assert_equal @user, @controller.current_user
      end
      should_not_change('the number of Users') { User.count }
      should_not_change('the number of Credentials') { Credential.count }
      should_redirect_to('home') { root_path }
    end
    
    context 'trying to sign in via Yupple' do
      setup do
        rpx_returns :providerName => 'Yupple', :identifier => 'http://yupple.net/people/843'
        post :create, :token => 'a token'
      end
      should 'not sign the User in' do
        assert !@controller.signed_in?
      end
      should_not_change('the number of Users') { User.count }
      should_not_change('the number of Credentials') { Credential.count }
    end
    
  end
  
end
