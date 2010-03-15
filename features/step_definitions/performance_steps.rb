Given /^I check my watch$/ do
  @checked_watch_at = Time.now
end

Then /^no more than (.+) seconds should have elapsed$/ do |max|
  raise "Couldn't find a timestamp. Have you checked your watch in this scenario?" unless @checked_watch_at
  max = max.to_f.seconds
  elapsed = Time.now - @checked_watch_at
  assert(elapsed <= max, "Expected no more than #{max} seconds to elapse, but was #{elapsed}.")
end
