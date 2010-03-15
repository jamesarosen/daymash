Then "I should be redirected" do
  assert((300..399).include?(status), "Expected redirect, but was #{status}")
end

Then /^I should be redirected to (.+)$/ do |expected|
  Then "I should be redirected"
  if (md = /^\/(.+)\/$/.match(expected))
    expected = Regexp.compile(md[1])
  else
    # try to translate to a path from /features/support/paths.rb
    expected = path_to(expected) rescue expected
  end
  actual = @integration_session.headers['Location']
  assert expected === actual, "Expected to be redirected to #{expected}, but was #{actual}"
end
