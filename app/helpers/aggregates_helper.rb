module AggregatesHelper
  
  def aggregate_link(user)
    url = user_aggregate_url user, :format => 'ics', :pt => user.privacy_token
    link_to url, url
  end
  
end
