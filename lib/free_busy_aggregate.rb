require 'ri_cal'
require 'fix_ri_cal_period'
require 'ri_cal/core_extensions/range'

class FreeBusyAggregate
  
  def initialize(*calendars)
    @calendars = calendars
  end
  
  def aggregate
    ::RiCal.Calendar do |cal|
      occurrences.each do |occurrence|
        cal.event do |event|
          event.summary = 'Busy'
          event.dtstart = occurrence.dtstart
          event.dtend   = occurrence.dtend
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
