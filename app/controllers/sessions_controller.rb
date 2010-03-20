require 'rpx_now'

class SessionsController < ApplicationController
  
  protect_from_forgery :except => [:create]
  
  def create
    data = RPXNow.user_data(params[:token], &RpxSupport::PARSE_RPX_DATA)
    user = User.find_and_update_from_rpx(data)
    if user
      self.current_user = user
    else
      self.current_user = nil
      flash[:error] = I18n.t('activerecord.errors.models.credential.notfound', :provider => data[:provider])
    end
    redirect_to root_path
  end
  
  def destroy
    self.current_user = nil
    flash[:notice] = 'Signed Out.'
    redirect_to root_path
  end
  
end
