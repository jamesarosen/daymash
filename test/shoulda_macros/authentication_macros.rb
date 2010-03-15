module AuthenticationMacros
  
  def sign_out!
    visit '/'
    return unless controller.signed_in?
    click_link 'Sign Out'
  end
  
  def sign_in_as(user, provider = :any)
    visit '/'
    return if controller.signed_in?
    if provider == :any
      if user.credentials.any?
        controller.current_user = user
      else
        raise "#{user} does not have any Credentials"
      end
    else
      if user.has_credential_from?(provider)
        controller.current_user = user
      else
        raise "#{user} does not have a Credential from #{provider}"
      end
    end
    user
  end
  
end
      