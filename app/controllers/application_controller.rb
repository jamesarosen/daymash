# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  include Authentication
  include AdvancedFlash::ControllerSupport
  
  helper :all, AdvancedFlash::Helper # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  ActionController::Rescue::DEFAULT_RESCUE_RESPONSES.each do |klass, method|
    rescue_from klass, :with => method
  end
  
  protected
  
  def requested_user(param = :id)
    @user ||= User.find(params[param])
  end
  
  # ERROR HANDLERS:
  
  def render_error_page(exception, error_name, status)
    @exception = exception
    render :template => "/pages/#{error_name}", :status => status
  end
  
  def unauthorized(ex = nil)
    render_error_page ex, :unauthorized, 401
  end
  
  def not_found(ex = nil)
    render_error_page ex, :not_found, 404
  end
  
  def method_not_allowed(ex = nil)
    render_error_page ex, :method_not_allowed, 405
  end
  
  def conflict(ex = nil)
    render_error_page ex, :conflict, 409
  end
  
  def unprocessable_entity(ex = nil)
    raise ex
    render_error_page ex, :unprocessable_entity, 422
  end
  
  def not_implemented(ex = nil)
    render_error_page ex, :not_implemented, 501
  end
  
end
