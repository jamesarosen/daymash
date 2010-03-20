class UsersController < ApplicationController
  
  protect_from_forgery :except => [:create]
  append_before_filter :require_signed_in, :except => [:create, :busy]
  
  def create
    if params[:token]
      data = RPXNow.user_data(params[:token], &RpxSupport::PARSE_RPX_DATA)
      @user, @credential = User.build_from_rpx(data)
    else
      @user = User.new(params[:user])
      @credential = saved_credential
    end
    if @user.save_with_credential(@credential)
      self.current_user = @user
      self.saved_credential = nil
      flash[:notice] = t('users.signed_up')
      redirect_to root_path
    else
      self.saved_credential = @credential
      render :action => :new
    end
  end
  
  def show
    @user = requested_user
  end
  
  def edit
    @user = requested_user
  end
  
  def update
    @user = requested_user
    @user.update_attributes(params[:user])
    if @user.save
      redirect_to root_path
    else
      render :action => 'edit'
    end
  end
  
  protected
  
  def saved_credential=(credential)
    if credential
      session[:saved_credential] = { :provider => credential.provider, :identifier => credential.identifier}
    else
      session[:saved_credential] = nil
    end
    saved_credential
  end
  
  def saved_credential
    if session[:saved_credential].blank?
      @_saved_credential = nil
    else
      @_saved_credential ||= Credential.new(session[:saved_credential])
    end
  end
  
end
