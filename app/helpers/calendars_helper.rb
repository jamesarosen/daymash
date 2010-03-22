module CalendarsHelper
  
  def calendars_list(user)
    content_tag :ul, :class => 'calendars' do
      user.calendars.map do |calendar|
        content_tag :li, :class => 'calendar' do
          content_tag(:span, calendar.title, :title => calendar.uri) +
            delete_calendar_form(:current, calendar)
        end
      end.join(' ')
    end
  end
  
  def delete_calendar_form(user, calendar)
    inline_button_to t('common.delete'), user_calendar_path(user.to_param, calendar), :delete
  end
  
end
