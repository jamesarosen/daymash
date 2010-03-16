class UsersController < ApplicationController
  
  append_before_filter :require_signed_in, :except => [:busy]
  
  def show
    @user = current_user
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
  
  def busy
    calendar = User.find(params[:id]).aggregate_freebusy_calendar
    render :text => calendar.to_s, :content_type => Mime::ICS
  end
  
end
