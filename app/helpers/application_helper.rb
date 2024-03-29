require 'add_uniq_by_to_array'

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def inline_button_to(button_text, path, method, options = {})
    klass = 'inline'
    klass << ' ' << options[:class] if options[:class].present?
    form_tag(path, :method => method, :class => klass) +
      content_tag(:button, :type => 'submit', :name => 'submit') do
        content_tag(:span, button_text)
      end +
      '</form>'
  end
  
  def site_nav_bar
    nav_bar(:site) do |nb|
      if signed_in?
        nb.nav_item :aggregate, user_aggregate_path(current_user)
        nb.nav_item :my_profile, user_path(current_user)
        nb.nav_item :sign_out
      else
        nb.nav_item :how_it_works, page_path(:how_it_works)
        nb.nav_item :sign_up, rpx_url(users_url)
        nb.nav_item :sign_in, rpx_url(sessions_url)
      end
    end
  end
  
  def google_analytics_scripts
    return <<-EOS
<script type="text/javascript">
  var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
  document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
  try {
    var pageTracker = _gat._getTracker("UA-7255350-2");
    pageTracker._trackPageview();
  } catch(err) {}
</script>
EOS
  end
  
  def sidebar(title = nil, &block)
    content_for :sidebar, (content_tag(:aside, :class => 'sidebar') {
      (title.present? ? content_tag(:h2, title) : '') +
      (block_given? ? capture(&block) : '')
    })
  end
    
end
