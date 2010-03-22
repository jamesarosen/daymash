class AggregatesController < ApplicationController
  
  def show
    @user = requested_user(:user_id)
    respond_to do |format|
      format.html do
        if signed_in?
          render :action => :show
        else
          unauthorized
        end
      end
      format.ics do
        if params[:pt] == @user.privacy_token
          calendar = @user.aggregate_freebusy_calendar
          render :text => calendar.to_s, :content_type => Mime::ICS
        else
          render :nothing => true, :status => :not_found
        end
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

end
