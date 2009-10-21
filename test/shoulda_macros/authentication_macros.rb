module AuthenticationMacros
  
  def sign_out!
    sign_in_as nil
  end
  
  def sign_in_as(user)
    if user.blank?
      UserSession.find.tap { |s| s.destroy if s.present? }
    else
      UserSession.create(user)
    end
  end
  
end
      