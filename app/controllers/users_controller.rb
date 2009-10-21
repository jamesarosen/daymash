class UsersController < ApplicationController
  
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
  
end
