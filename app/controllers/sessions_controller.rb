require 'rpx_now'

class SessionsController < ApplicationController
  
  protect_from_forgery :except => [:create] 
  
  def create
    data = RPXNow.user_data(params[:token], &RpxSupport::PARSE_RPX_DATA)
    user = User.find_or_initialize_with_rpx(data)
    if user.new_record?
      flash[:error] = 'Error signing in.'
      self.current_user = nil
    else
      self.current_user = user
    end
    redirect_to root_path
  end
  
  def destroy
    self.current_user = nil
    flash[:notice] = 'Signed Out.'
    redirect_to root_path
  end
  
end
