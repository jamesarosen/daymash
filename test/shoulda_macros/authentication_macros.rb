module AuthenticationMacros
  
  def sign_out!
    visit '/'
    return unless controller.signed_in?
    click_link 'Sign Out'
  end
  
  def sign_in_as(user, password = 'password')
    visit '/'
    return if controller.signed_in?
    click_link 'Sign In'
    fill_in 'user_session_principal', :with => user.username
    fill_in 'user_session_password',  :with => password
    click_button 'user_session_submit'
  end
  
end
      