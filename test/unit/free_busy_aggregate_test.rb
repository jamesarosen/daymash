require 'test_helper'

class FreeBusyAggregateTest < Test::Unit::TestCase
  
  context 'aggregating a single calendar with a single event' do
    
    setup do
      @calendar = RiCal.Calendar do |cal|
        cal.event do |evt|
          evt.summary     'Private Stuff'
          evt.description "I really don't want people to know about this"    
          evt.dtstart     DateTime.parse("2/14/2011 18:22:00")
          evt.dtend       DateTime.parse("2/14/2011 19:45:00")
          evt.location    'Nowhere you need to know about'
        end
      end
      @aggregate = FreeBusyAggregate.aggregate(@calendar)
    end
    
    should 'yield an aggregate calendar with no events' do
      assert_equal 0, @aggregate.events.size
    end
    
    should 'yield an aggregate calendar with a single free-busy' do
      assert_equal 1, @aggregate.freebusys.size
    end
    
    should 'yield an aggregate with a matching free-busy' do
      event    = @calendar.events.first
      freebusy = @aggregate.freebusys.first
      assert_equal event.start_time,  freebusy.dtstart
      assert_equal event.finish_time, freebusy.dtend
    end
    
    should 'not reveal the details of the original event' do
      event    = @calendar.events.first
      freebusy = @aggregate.freebusys.first
      assert !(freebusy.to_s.include?(event.summary))
      assert !(freebusy.to_s.include?(event.description))
      assert !(freebusy.to_s.include?(event.location))
    end
    
  end
  
  context 'aggregating several calendars, each with a single event' do
    
    setup do
      @parties = RiCal.Calendar do |cal|
        cal.event do |evt|
          evt.description "Vishal's Birthday Party"
          evt.dtstart     DateTime.parse("12/01/2009 19:00:00")
          evt.dtend       DateTime.parse("12/01/2009 23:00:00")
          evt.location    "Vishal's House"
        end
      end
      @dates = RiCal.Calendar do |cal|
        cal.event do |evt|
          evt.description "Dinner with Sue"
          evt.dtstart     DateTime.parse("12/08/2009 19:30:00")
          evt.dtend       DateTime.parse("12/08/2009 22:00:00")
          evt.location    "Three Monkey Island"
        end
      end
      @aggregate = FreeBusyAggregate.aggregate(@parties, @dates)
    end
    
    should 'yield a calendar with no events' do
      assert_equal 0, @aggregate.events.size
    end
    
    should 'yield a calendar with two free-busys' do
      assert_equal 2, @aggregate.freebusys.size
    end
    
    should 'yield matching free-busys' do
      (@parties.events + @dates.events).each do |event|
        assert(@aggregate.freebusys.find do |fb|
          fb.dtstart == event.start_time && fb.dtend == event.finish_time
        end.present?)
      end
    end
    
  end
  
end
