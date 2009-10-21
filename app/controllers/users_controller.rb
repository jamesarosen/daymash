class UsersController < ApplicationController
  
  def new
    @user ||= User.new
  end
  
  def create
    @user ||= User.new(params[:user])
    if @user.save
      sign_in(@user)
      redirect_to root_path
    else
      render :action => 'new'
    end
  end
  
  private
  
  def sign_in(user)
    UserSession.create(user)
  end
  
end
