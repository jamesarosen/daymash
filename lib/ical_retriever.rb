class IcalRetriever
  
  def initialize(proxy_uri = nil)
    @retriever = if proxy_uri.present?
      proxy_uri = URI.parse(proxy_uri) unless proxy_uri.kind_of?(URI)
      Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port)
    else
      Net::HTTP
    end
  end
  
  def fetch_and_parse(calendar)
    RiCal.parse_string(fetch(calendar))
  end
  
  def fetch_and_parse_all(calendars)
    calendars.inject([]) do |sum, calendar|
      sum += fetch_and_parse(calendar)
    end
  end
  
  protected
  
  def fetch(calendar)
    uri = URI.parse(calendar.uri)
    res = @retriever.start(uri.host) do |http|
      req = Net::HTTP::Get.new(uri.path)
      req.basic_auth uri.user, uri.password if uri.user.present?
      res = http.request req
    end
    res.body
  end
  
end
