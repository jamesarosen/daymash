class CalendarsController < ApplicationController
  
  append_before_filter :require_signed_in
  
  def index
    @user = current_user
  end
  
end
