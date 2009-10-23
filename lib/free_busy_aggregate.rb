require 'ri_cal'
require 'fix_ri_cal_period'
require 'ri_cal/core_extensions/range'

class FreeBusyAggregate
  
  def initialize(*calendars)
    @calendars = calendars
  end
  
  def aggregate
    ::RiCal.Calendar do |cal|
      cal.freebusy do |fb_block|
        fb_block.dtstart = Time.now
        fb_block.dtend   = Time.now + 2.months
        occurrences.each do |occurrence|
          fb_block.add_freebusy(occurrence.start_time..occurrence.finish_time)
        end
      end
    end
  end
  
  protected
  
  attr_reader :calendars
  
  def occurrences
    calendars.map(&:events).flatten.map do |event|
      event.occurrences(:before => Time.now + 2.months)
    end.flatten
  end
    
end
