require 'test_helper'

class FreeBusyAggregateTest < ActiveSupport::TestCase
  
  context 'aggregating a single RiCal Calendar with a single event' do
    
    setup do
      @calendar = RiCal.Calendar do |cal|
        cal.event do |evt|
          evt.summary     = 'Private Stuff'
          evt.description = "I really don't want people to know about this"    
          evt.dtstart     = 2.days.from_now
          evt.dtend       = (2.days + 2.hours).from_now
          evt.location    = 'Nowhere you need to know about'
        end
      end
      @aggregate = FreeBusyAggregate.new(@calendar).aggregate
    end
    
    should 'yield an aggregate calendar with one event' do
      assert_equal 1, @aggregate.events.size
    end
    
    should 'yield an aggregate with a matching event entry' do
      event    = @calendar.events.first
      freebusy = @aggregate.events.first
      assert_equal event.start_time,  freebusy.dtstart
      assert_equal event.finish_time, freebusy.dtend
    end
    
    should 'not reveal the details of the original event' do
      event = @calendar.events.first
      assert !(@aggregate.to_s.include?(event.summary))
      assert !(@aggregate.to_s.include?(event.description))
      assert !(@aggregate.to_s.include?(event.location))
    end
    
  end
  
  context 'aggregating several RiCal calendars, each with a single event' do
    
    setup do
      @parties = RiCal.Calendar do |cal|
        cal.event do |evt|
          evt.summary     = "Vishal's Birthday Party"
          evt.description = "Petting zoo FTW!"
          evt.dtstart     = 5.days.from_now
          evt.dtend       = (5.days + 5.hours).from_now
          evt.location    = "Vishal's House"
        end
      end
      @dates = RiCal.Calendar do |cal|
        cal.event do |evt|
          evt.summary     = "Dinner with Sue"
          evt.description = "Reminder: Sue loves caramel"
          evt.dtstart     = 6.days.from_now
          evt.dtend       = (6.days + 3.hours).from_now
          evt.location    = "Three Monkey Island"
        end
      end
      @aggregate = FreeBusyAggregate.new(@parties, @dates).aggregate
    end
    
    should 'yield a calendar with two events' do
      assert_equal 2, @aggregate.events.size
    end
    
    should 'yield matching events' do
      freebusy_entries = @aggregate.events
      (@parties.events + @dates.events).each do |event|
        assert(freebusy_entries.find do |fb|
          fb.dtstart.to_datetime == event.dtstart.to_datetime &&
          fb.dtend.to_datetime   == event.dtend.to_datetime
        end.present?, "Could not find #{event.summary} in the aggregate feed.")
      end
    end
    
    should 'not reveal the details of the original events' do
      aggregate = @aggregate.to_s
      assert !(aggregate.include?(@parties.events.first.summary))
      assert !(aggregate.include?(@parties.events.first.description))
      assert !(aggregate.include?(@parties.events.first.location))
      assert !(aggregate.include?(@dates.events.first.summary))
      assert !(aggregate.include?(@dates.events.first.description))
      assert !(aggregate.include?(@dates.events.first.location))
    end
    
  end
  
end
