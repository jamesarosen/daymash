require 'test_helper'
require 'fix_ri_cal_period'
require 'ri_cal/core_extensions/range'

UsersController.class_eval do
  def public_saved_credential=(c)
    self.saved_credential = c
  end
  def public_saved_credential
    saved_credential
  end
end

class UsersControllerTest < ActionController::TestCase

  def setup
    super
    @laila = Factory(:user, :display_name => 'Laila Z. Ziggy')
  end
  
  context 'signing up' do
    
    context 'via a provider that provides an email address not already in use' do
      setup do
        rpx_returns :providerName => 'Foobar', :identifier => 'http://foobar.com/me', :verifiedEmail => 'me@foobar.com'
        post :create, {:token => 'anything'}, @controller.session
      end
      should_change('the number of Users', :by => 1) { User.count }
      should_change('the number of Credentials', :by => 1) { Credential.count }
      should 'sign the User in' do
        assert @controller.current_user.present?
        assert_equal 'me@foobar.com', @controller.current_user.email
      end
      should_redirect_to('home') { root_path }
    end
    
    context 'via a provider that provides an email address already in use' do
      setup do
        rpx_returns :providerName => 'Golf', :identifier => 'http://golf.com/1', :verifiedEmail => @laila.email
        post :create, {:token => 'something'}, @controller.session
      end
      should_not_change('the number of Users') { User.count }
      should_not_change('the number of Credentials') { Credential.count }
      should_assign_to :user
      should_render_template :new
      should "save the passed credential" do
        assert @controller.public_saved_credential.present?
        assert_equal 'Golf', @controller.public_saved_credential.provider
        assert_equal 'http://golf.com/1', @controller.public_saved_credential.identifier
        assert_equal @user, @controller.public_saved_credential.user
      end
    end
    
    context 'via a provider that does not provide an email address' do
      setup do
        rpx_returns :providerName => 'Fazbot', :identifier => 'http://me.fazbot.com'
        post :create, {:token => 'anything'}, @controller.session
      end
      should_not_change('the number of Users') { User.count }
      should_assign_to :user
      should_render_template :new
      should "save the passed credential" do
        assert @controller.public_saved_credential.present?
        assert_equal 'Fazbot', @controller.public_saved_credential.provider
        assert_equal 'http://me.fazbot.com', @controller.public_saved_credential.identifier
        assert_equal @user, @controller.public_saved_credential.user
      end
    end
    
    context 'by providing an email address manually after trying to sign up via a provider that does not provide one' do
      setup do
        @credential = Factory.build(:credential, :identifier => 'http://yuppo.net/people/12')
        @controller.public_saved_credential = @credential
        post :create, {:user => { :email => 'me@yuppo.net' }}, @controller.session
      end
      should_change('the number of Users', :by => 1) { User.count }
      should_change('the number of Credentials', :by => 1) { Credential.count }
      should 'sign the User in' do
        assert @controller.current_user.present?
        assert_equal 'me@yuppo.net', @controller.current_user.email
      end
      should_redirect_to('home') { root_path }
    end
    
  end
  
  context 'a signed-out visitor' do
  
    context "trying to view a user's profile" do
      setup { get :show, :id => @laila.to_param }
      should_respond_with :unauthorized
    end

    context "trying to edit a user's profile" do
      setup { get :edit, :id => @laila.to_param }
      should_respond_with :unauthorized
    end
  
    context "trying to update a user's profile" do
      setup { put :update, :id => @laila.to_param, :user => { :display_name => 'hacked' } }
      should_not_change("the user's display name") { @laila.reload.display_name }
      should_respond_with :unauthorized
    end
  
    context "retrieving a User's free-busy feed" do
    
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
  
  context 'a signed-in user' do
    
    setup { @controller.stubs(:current_user).returns(@laila) }
    
    context 'viewing her account information' do
      setup { get :show, :id => @laila.to_param }
      should_respond_with :success
      should_render_template :show
    end
  
    context "editing her profile" do
      setup { get :edit, :id => @laila.to_param }
      should_respond_with :success
      should_render_template :edit
    end
    
    context "updating her profile" do
      setup { post :update, :id => @laila.to_param, :user => { :display_name => 'zigz' } }
      should_redirect_to('home') { root_path }
      should_change("the display name", :to => 'zigz') { @laila.reload.display_name }
    end
    
  end

end
