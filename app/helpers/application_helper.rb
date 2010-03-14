# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def site_nav_bar
    nav_bar(:site) do |nb|
      if signed_in?
        if current_user.calendars.any?
          nb.nav_item :aggregate, busy_user_path(current_user, :format => :ics)
        end
        nb.nav_item :my_calendars, user_calendars_path(:user_id => :current)
        nb.nav_item :edit_profile, edit_user_path(:current)
        nb.nav_item :sign_out
      else
        nb.nav_item :sign_up, new_user_path
        nb.nav_item :sign_in, new_user_session_path
      end
    end
  end
  
end
