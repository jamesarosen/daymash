# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  helper_method :current_user, :signed_in?
  
  hide_action :current_user, :signed_in?
  
  def current_user
    @current_user ||= begin
      current_user_session && current_user_session.record
    end
  end
  
  def signed_in?
    current_user.present?
  end
  
  protected
  
  def current_user_session
    @current_user_session ||= UserSession.find
  end
  
end
