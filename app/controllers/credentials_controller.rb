class CredentialsController < ApplicationController
  
  protect_from_forgery :except => [:create]
  append_before_filter :require_signed_in
  append_before_filter :ensure_not_destroying_last_credential, :only => [:destroy]

  def create
    user = requested_user(:user_id)
    data = RPXNow.user_data(params[:token], &RpxSupport::PARSE_RPX_DATA)
    credential = user.update_and_add_credential_from_rpx(data)
    user.save # save any changes to user information but ignore problems
    if credential.save
      flash[:notice] = t('credentials.added', :provider => credential.provider)
    else
      flash[:error] = t('credentials.add_failed', :provider => credential.provider, :identifier => credential.identifier)
    end
    redirect_to user_path(params[:user_id])
  end
  
  def destroy
    if credential.destroy
      add_deleted_credential_flash credential
    end
    respond_to do |format|
      format.html { redirect_to user_path(params[:user_id]) }
      format.js { render :layout => false }
    end
  end
  
  def undestroy
    credential = Credential::Archive.find_by_user_and_id!(requested_user(:user_id), params[:id])
    credential.restore
    flash[:notice] = t("credentials.undeleted", :provider => credential.provider)
    redirect_to user_path(params[:user_id])
  end
  
  protected
  
  def credential
    @credential ||= requested_user(:user_id).credentials.find(params[:id])
  end
  
  def ensure_not_destroying_last_credential
    if credential.last_credential_for_user?
      flash[:error] = t('credentials.cannot_delete_last')
      redirect_to user_path(params[:user_id])
    end
  end

end
