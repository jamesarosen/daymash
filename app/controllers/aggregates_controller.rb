class AggregatesController < ApplicationController
  
  append_before_filter :authorize_show, :only => :show
  
  def show
    @user = requested_user(:user_id)
    respond_to do |format|
      format.html
      format.ics do
        calendar = @user.aggregate_freebusy_calendar
        render :text => calendar.to_s, :content_type => Mime::ICS
      end
    end
  end
  
  def reset_privacy_token
    @user = requested_user(:user_id)
    if @user.reset_privacy_token
      flash[:notice] = t('aggregates.privacy_token.updated')
    else
      flash[:error] = t('aggregates.privacy_token.error_updating')
    end
    respond_to do |format|
      format.html { redirect_to user_aggregate_path(:user_id => params[:user_id]) }
      format.js   { render :layout => false }
    end
  end
  
  protected
  
  # Show as ICS allowed iff privacy token supplied.
  # Otherwise, allowed iff requested user is current user.
  def authorize_show
    user = requested_user(:user_id)
    if request.format == Mime::ICS
      unauthorized("Invalid privacy token.") unless params[:pt] == user.privacy_token
    else
      unauthorized unless user == current_user
    end
    true
  end

end
