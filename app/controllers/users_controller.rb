class UsersController < ApplicationController
  
  append_before_filter :require_signed_in, :only => [:edit, :update]
  
  def new
    @user ||= User.new
  end
  
  def create
    @user ||= User.new(params[:user])
    if @user.save
      UserSession.create(@user)
      redirect_to root_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    @user.update_attributes(params[:user])
    if @user.save
      redirect_to root_path
    else
      render :action => 'edit'
    end
  end
  
end
