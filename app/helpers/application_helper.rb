# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def inline_button_to(path, method, button_text)
    form_tag(path, :method => method, :class => :inline) +
      content_tag(:button, :type => 'submit', :name => 'submit') do
        content_tag(:span, button_text)
      end +
      '</form>'
  end
  
  def site_nav_bar
    nav_bar(:site) do |nb|
      if signed_in?
        if current_user.calendars.any?
          nb.nav_item :aggregate, user_aggregate_path(:user_id => :current)
        end
        nb.nav_item :my_calendars, user_calendars_path(:user_id => :current)
        nb.nav_item :my_profile, user_path(:current)
        nb.nav_item :sign_out
      else
        nb.nav_item :sign_up, rpx_url(users_url)
        nb.nav_item :sign_in, rpx_url(sessions_url)
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
  
  def rpx_url(return_to)
    "https://daymash.rpxnow.com/openid/v2/signin?token_url=#{URI.encode return_to}"
  end
  
end
