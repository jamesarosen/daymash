require 'test_helper'

class CredentialsControllerTest < ActionController::TestCase
  
  def setup
    super
    @other_user = Factory(:user)
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
    
    context 'adding a credential' do
      setup do
        rpx_returns :providerName => 'Sukoda', :identifier => 'http://sukoda.com/12459'
        post :create, :user_id => :current, :token => 'anything'
      end
      should_redirect_to("the user's profile page") { user_path(:current) }
      should_change("the number of the user's credentials", :by => 1) { @pierre.credentials(true).count }
    end
    
    context 'trying to add a credential that is already in use' do
      setup do
        other_credential = @other_user.credentials.first
        rpx_returns({ :providerName => other_credential.provider,
                      :identifier => other_credential.identifier })
        post :create, :user_id => :current, :token => 'anything'
      end
      should_redirect_to("the user's profile page") { user_path(:current) }
      should_not_change("the number of the user's credentials") { @pierre.credentials(true).count }
    end
    
    context "deleting a credential" do
      setup { delete :destroy, :user_id => :current, :id => @openid.to_param }
      should_redirect_to("the user's profile page") { user_path(:current) }
      should_change("the number of the user's credentials", :by => -1) { @pierre.credentials(true).count }
      should "store the deleted credential's ID in the session for undo purposes" do
        assert_equal @openid.id, @controller.session[AdvancedFlash::DELETED_CREDENTIAL_SESSION_ID]
      end
      should_set_the_flash_to AdvancedFlash::DELETED_CREDENTIAL_FLASH
    end
    
    context 'deleting a credential via AJAX' do
      setup { xhr :delete, :destroy, :user_id => :current, :id => @openid.to_param }
      should_render_template :destroy
      should_change("the number of the user's credentials", :by => -1) { @pierre.credentials(true).count }
      should "remove the relevant DOM element" do
        assert_match /DayMash\.deleteCredential\('#{@openid.to_param}'\);/, @response.body
      end
    end
    
    context 'with a deleted credential' do
      setup { @openid.destroy }
      
      context "un-deleting that credential" do
        setup { put :undestroy, :user_id => :current, :id => @openid.to_param }
        should_redirect_to("the user's profile page") { user_path(:current) }
        should_change("the number of the user's credentials", :by => 1) { @pierre.credentials(true).count }
      end
      
      context 'un-deleting that credential via AJAX' do
        setup { xhr :put, :undestroy, :user_id => :current, :id => @openid.to_param }
        should_render_template :undestroy
        should_change("the number of the user's credentials", :by => 1) { @pierre.credentials(true).count }
        should "insert the new Credential in the DOM" do
          assert_match /DayMash\.insertCredential\(/, @response.body
        end
      end
    end
    
    context "with only one credential" do
      
      setup { @facebook.destroy }
      
      context "trying to delete his last credential" do
        setup { delete :destroy, :user_id => :current, :id => @openid.to_param }
        should_redirect_to("the user's profile page") { user_path(:current) }
        should_set_the_flash_to(/cannot (?:delete|destroy|remove)/i)
        should_not_change("the nubmer of the user's credentials") { @pierre.credentials(true).count }
      end
      
    end
    
  end

end
