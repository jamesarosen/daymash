require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @clarence = Factory(:user, :display_name => 'Clarence Biggs')
    @laila    = Factory(:user, :display_name => 'Laila Z. Ziggy')
  end

  context 'a signed-out visitor trying to edit a profile' do
    setup { get :edit, :id => @laila.to_param }
    should_respond_with :unauthorized
  end
  
  context 'a signed-out visitor trying to update a profile' do
    setup { put :update, :id => @laila.to_param, :user => { :useranme => 'hacked' } }
    should_respond_with :unauthorized
  end

end
