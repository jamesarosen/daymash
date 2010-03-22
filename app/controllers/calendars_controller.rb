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
      redirect_to user_aggregate_path(:user_id => :current)
    else
      render :action => :new
    end
  end
  
  def destroy
    if calendar.destroy
      add_deleted_calendar_flash calendar
    end
    redirect_to user_calendars_path(params[:user_id])
  end
  
  def undestroy
    calendar = Calendar::Archive.find_by_user_and_id!(requested_user(:user_id), params[:id])
    calendar.restore
    flash[:notice] = t("calendars.undeleted", :title => calendar.title)
    redirect_to user_calendars_path(params[:user_id])
  end
  
  protected
  
  def calendar
    @calendar ||= requested_user(:user_id).calendars.find(params[:id])
  end
  
end
