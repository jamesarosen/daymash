class CalendarsController < ApplicationController
  
  append_before_filter :require_signed_in
  caches_action :index, :layout => false
  cache_sweeper :calendar_sweeper, :only => [:crate, :destroy, :undestroy]
  
  def index
    @user = current_user
  end
  
  def new
    @calendar ||= Calendar.new
  end
  
  def create
    @calendar ||= Calendar.new(params[:calendar])
    if current_user.calendars << @calendar
      redirect_to user_aggregate_path(current_user)
    else
      render :action => :new
    end
  end
  
  def destroy
    if calendar.destroy
      add_deleted_calendar_flash calendar
    end
    respond_to do |format|
      format.html { redirect_to user_aggregate_path(current_user) }
      format.js { render :layout => false }
    end
  end
  
  def undestroy
    old_calendar = Calendar::Archive.find_by_user_and_id!(requested_user(:user_id), params[:id])
    @calendar = old_calendar.restore
    flash[:notice] = t("calendars.undeleted", :title => @calendar.title)
    respond_to do |format|
      format.html { redirect_to user_aggregate_path(params[:user_id]) }
      format.js { render :layout => false }
    end
  end
  
  protected
  
  def calendar
    @calendar ||= requested_user(:user_id).calendars.find(params[:id])
  end
  
end
