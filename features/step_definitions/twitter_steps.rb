Given /^a mock connection to Twitter$/ do
  mock_twitter!
end

module TwitterSupport
  
  class MockTwitterResults
    attr_reader :results
    def initialize; @results = []; end
    def respond_to?(method); true; end
    def method_missing(name, *args, &block); self; end
  end
  
  def mock_twitter!
    Twitter::Search.stubs(:new).returns(MockTwitterResults.new)
  end
  
end

World(TwitterSupport)
