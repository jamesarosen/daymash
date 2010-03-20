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
        calendar = @user.aggregate_freebusy_calendar
        render :text => calendar.to_s, :content_type => Mime::ICS
      end
    end
  end

end
