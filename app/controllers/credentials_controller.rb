class CredentialsController < ApplicationController
  
  append_before_filter :require_signed_in
  append_before_filter :ensure_not_destroying_last_credential, :only => [:destroy]

  def destroy
    if credential.destroy
      add_deleted_credential_flash credential
    end
    redirect_to user_path(:current)
  end
  
  def undestroy
    credential = Credential::Archive.find_by_user_and_id!(current_user, params[:id])
    credential.restore
    flash[:notice] = t("credentials.undeleted", :provider => credential.provider)
    redirect_to user_path(:current)
  end
  
  protected
  
  def user
    @user ||= current_user
  end
  
  def credential
    @credential ||= user.credentials.find(params[:id])
  end
  
  def ensure_not_destroying_last_credential
    if credential.last_credential_for_user?
      flash[:error] = t('credentials.cannot_delete_last')
      redirect_to user_path(:current)
    end
  end

end
