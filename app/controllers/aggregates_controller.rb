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

end
