require 'test_helper'

class SignUpTest < ActionController::IntegrationTest
  
  include AuthenticationMacros
  
  setup :activate_authlogic

  context 'a signed-out visitor' do
    
    setup { sign_out! }
    
    should 'be able to register' do
      visit '/'
      click_link 'Sign Up'
      fill_in 'Username', :with => 'ppatel'
      fill_in 'Email', :with => 'ppatel@exmaple.org'
      fill_in 'user[display_name]', :with => 'Petra Patel'
      fill_in 'Password', :with => 'password'
      fill_in 'user[password_confirmation]', :with => 'password'
      click_button "Let's Get Schedulin'"
      assert_equal 'Petra Patel', controller.send(:current_user).to_s
    end
    
  end
  
end
