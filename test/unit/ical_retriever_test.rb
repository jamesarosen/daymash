require 'test_helper'
require 'fakeweb'

class IcalRetrieverTest < ActiveSupport::TestCase
  
  def ics_fixture(name)
    File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', "#{name}.ics"))
  end
  
  context 'retrieving an iCal feed for a Calendar object' do
    
    setup do
      @calendar = Factory(:calendar)
      @ics = ics_fixture(:parties)
      FakeWeb.register_uri(:get, @calendar.uri, :body => @ics)
      @retrieved_ics = IcalRetriever.new.fetch(@calendar)
    end
    
    should "fetch the proper iCal content" do
      assert_equal @ics, @retrieved_ics
    end
    
  end
  
end
