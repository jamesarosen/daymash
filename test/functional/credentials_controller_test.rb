require 'test_helper'

class CredentialsControllerTest < ActionController::TestCase
  
  def setup
    @pierre = Factory(:user, :display_name => 'Pierre P. Petrus')
    @openid = @pierre.credentials.first
    @facebook = Factory(:credential, :user => @pierre, :provider => 'Facebook')
  end
  
  context 'a signed-out visitor' do
  
    context "trying to delete a user's credential" do
      setup { delete :destroy, :user_id => @pierre.to_param, :id => @openid.to_param }
      should_respond_with :unauthorized
    end
    
  end
  
  context 'a signed-in user' do
    
    setup { @controller.stubs(:current_user).returns(@pierre) }
    
    context "deleting a credential" do
      setup { delete :destroy, :user_id => @pierre.to_param, :id => @openid.to_param }
      should_redirect_to("the user's profile page") { user_path(:current) }
      should_change("the number of the user's credentials", :by => -1) { @pierre.credentials(true).count }
    end
    
    context "with only one credential" do
      
      setup { @facebook.destroy }
      
      context "trying to delete his last credential" do
        setup { delete :destroy, :user_id => @pierre.to_param, :id => @openid.to_param }
        should_redirect_to("the user's profile page") { user_path(:current) }
        should_set_the_flash_to(/cannot (?:delete|destroy|remove)/i)
        should_not_change("the nubmer of the user's credentials") { @pierre.credentials(true).count }
      end
      
    end
    
  end

end
