class CalendarsController < ApplicationController
  
  append_before_filter :require_signed_in
  
  def index
    @user = current_user
  end
  
  def new
    @calendar ||= Calendar.new
  end
  
  def create
    @calendar ||= Calendar.new(params[:calendar])
    if current_user.calendars << @calendar
      redirect_to user_calendars_path(:user_id => :current)
    else
      render :action => :new
    end
  end
  
end
