class CalendarSweeper < ActionController::Caching::Sweeper
  observe Calendar
  
  def after_save(calendar)
    sweep_up_after_calendar(calendar)
  end
  
  def after_destroy(calendar)
    sweep_up_after_calendar(calendar)
  end
  
  def sweep_up_after_calendar(calendar)
    expire_action :controller => :calendars,
                  :action => :index
                  
    expire_action :controller => :aggregates,
                  :action => :show,
                  :user_id => calendar.user,
                  :format => [nil, 'html', 'ics']
  end
end
