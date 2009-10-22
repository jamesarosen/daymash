module AuthenticationMacros
  
  def sign_out!
    delete sign_out_path
  end
  
  def sign_in_as(user, password = 'password')
    post new_user_session_path :principal => user.username, :password => password
  end
  
end
      