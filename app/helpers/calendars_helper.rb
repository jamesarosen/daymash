module CalendarsHelper
  
  def calendars_list(user)
    content_tag :ul, :class => 'calendars' do
      user.calendars.map do |calendar|
        calendar_li user, calendar
      end.join(' ')
    end
  end
  
  def calendar_li(user, calendar)
    content_tag :li, :class => 'calendar', :id => calendar.to_param do
      content_tag(:span, calendar.title, :title => calendar.uri) +
        delete_calendar_form(user, calendar)
    end
  end
  
  def delete_calendar_form(user, calendar)
    inline_button_to t('common.delete'), user_calendar_path(user, calendar), :delete, :class => 'ajax'
  end
  
end
