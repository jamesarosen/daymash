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
        nb.nav_item :sign_up, rpx_url
        nb.nav_item :sign_in, rpx_url
      end
    end
  end
  
  def rpx_scripts
    return <<-EOS
<script type="text/javascript">
  var rpxJsHost = (("https:" == document.location.protocol) ? "https://" : "http://static.");
  document.write(unescape("%3Cscript src='" + rpxJsHost +
"rpxnow.com/js/lib/rpx.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
  RPXNOW.overlay = true;
  RPXNOW.language_preference = 'en';
</script>
EOS
  end
  
  def rpx_url
    "https://daymash.rpxnow.com/openid/v2/signin?token_url=#{URI.encode sessions_url}"
  end
  
end
