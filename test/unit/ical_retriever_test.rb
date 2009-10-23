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
      @retrieved_ics = IcalRetriever.new.fetch(@parties)
    end
    
    should "fetch the proper iCal content" do
      assert_equal @parties_ics, @retrieved_ics
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
      @retrieved_ics = IcalRetriever.new.fetch_all(@user.calendars)
    end
    
    should 'fetch the proper iCal content' do
      assert_equal [@parties_ics, @yoga_ics], @retrieved_ics
    end
    
  end
  
end
