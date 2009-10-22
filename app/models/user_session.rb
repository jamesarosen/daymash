class UserSession < Authlogic::Session::Base
  
  self.find_by_login_method = :find_by_username_or_email
  self.login_field = :principal
  
end