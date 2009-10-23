require 'ri_cal'

module FreeBusyAggregate
  
  def self.aggregate(*calendars)
    ::RiCal.Calendar do |cal|
      calendars.map(&:events).flatten.each do |evt|
        cal.freebusy do |fb|
          fb.dtstart = evt.start_time
          fb.dtend   = evt.finish_time
        end
      end
    end
  end
    
end
