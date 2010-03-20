module Authentication
  
  def self.included(base)
    base.send :include, Authentication::InstanceMethods
    base.helper_method :current_user, :signed_in?
    base.hide_action   :current_user, :signed_in?
  end
  
  module InstanceMethods
  
    def current_user
      return nil if session[:current_user_id].blank?
      @_current_user ||= User.find(session[:current_user_id])
    end
  
    def current_user=(u)
      case u
      when nil
        @_current_user = session[:current_user_id] = nil
      when User
        @_current_user = u
        session[:current_user_id] = u.id
      when Integer
        self.current_user = User.find(u)
      else
        raise "Cannot convert #{u} into a User"
      end
      @_current_user
    end
  
    def signed_in?
      current_user.present?
    end
  
    protected
  
    def require_signed_in
      return true if signed_in?
      flash[:failure] = "Sorry, signed-in users only."
      unauthorized
      false
    end
  
  end

end
