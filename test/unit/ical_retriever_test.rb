require 'test_helper'
require 'fakeweb'

class IcalRetrieverTest < ActiveSupport::TestCase
  
  def ics_fixture(name)
    File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', "#{name}.ics"))
  end
  
  context 'retrieving an iCal feed for a Calendar object' do
    
    setup do
      @parties = Factory(:calendar, :title => 'Parties')
      @parties_ics = ics_fixture(:parties)
      FakeWeb.register_uri(:get, @parties.uri, :body => @parties_ics)
      @retrieved_calendars = IcalRetriever.new.fetch_and_parse(@parties)
    end
    
    should 'return a RiCal Calendar' do
      assert_equal RiCal::Component::Calendar, @retrieved_calendars.first.class
    end
    
    should "fetch the proper iCal content" do
      events = @retrieved_calendars.map(&:events).flatten
      assert events.find { |e| e.summary == "Lester's Mustache Bash" }.present?
      assert events.find { |e| e.summary == "Block Party" }.present?
    end
    
  end
  
  context 'retrieving several iCal feeds for a User object' do
    
    setup do
      @user         = Factory(:user)
      @parties      = Factory(:calendar, :title => 'Parties', :uri => 'http://parties.com/jeff.ics', :user => @user)
      @yoga         = Factory(:calendar, :title => 'Yoga',    :uri => 'http://yoga.org/intermediate.ics', :user => @user)
      @parties_ics  = ics_fixture(:parties)
      @yoga_ics     = ics_fixture(:yoga)
      FakeWeb.register_uri(:get, @parties.uri, :body => @parties_ics)
      FakeWeb.register_uri(:get, @yoga.uri,    :body => @yoga_ics)
      @retrieved_calendars = IcalRetriever.new.fetch_and_parse_all(@user.calendars)
    end
    
    should 'return RiCal Calendars' do
      @retrieved_calendars.each do |cal|
        assert_equal RiCal::Component::Calendar, cal.class
      end
    end
    
    should 'fetch the proper iCal content' do
      events = @retrieved_calendars.map(&:events).flatten
      assert events.find { |e| e.summary == "Lester's Mustache Bash" }.present?
      assert events.find { |e| e.summary == "Block Party" }.present?
      assert_equal 2, events.select { |e| e.summary == "Yoga" }.size
    end
    
  end
  
end
