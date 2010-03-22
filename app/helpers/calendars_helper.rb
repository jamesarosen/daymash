module CalendarsHelper
  
  def delete_calendar_form(user, calendar)
    inline_button_to user_calendar_path(:current, calendar), :delete, t('common.delete')
  end
  
end
