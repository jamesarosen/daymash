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

  context 'a new user who has just signed in via Facebook' do
    setup do
      User.delete_all
      Credential.delete_all
      @controller.session.clear
      FakeWeb.allow_net_connect = false
      FakeWeb.register_uri(:post, %r|^https://rpxnow.com/api/v2/auth_info|, :body => FACEBOOK_RESPONSE)
      post :create, :token => 'a token'
    end
    should 'create a new user' do
      assert_equal 1, User.count
      u = User.first
      assert_equal "Yags Hound", u.display_name
    end
    should 'sign the user in' do
      assert @controller.signed_in?
    end
    should_redirect_to('home') { root_path }
  end
  
end
