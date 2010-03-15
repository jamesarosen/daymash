unless Object.const_defined?(:FIRST_NAMES)
  # the lengths of these three arrays should be relatively prime:
  FIRST_NAMES     = %w{Jethro Anthony Abby Donald Timothy Ziva Caitlin Leon Mike}
  MIDDLE_INITIALS = ('A'..'Z').to_a
  LAST_NAMES      = %w{Gibbs DiNozzo Sciuto Mallard McGee David Todd}
end

Factory.sequence :name do |n|
  first_name      = FIRST_NAMES[n % FIRST_NAMES.length]
  middle_initial  = MIDDLE_INITIALS[n % MIDDLE_INITIALS.length]
  last_name       = LAST_NAMES[n % LAST_NAMES.length]
  "#{first_name} #{middle_initial}. #{last_name}"
end

Factory.sequence :email do |n|
  "user#{'%03d' % n}@example.org"
end

Factory.sequence :openid_url do |n|
  "http://user#{'%03d' % n}.example.org"
end

Factory.define :user do |user|
  user.display_name { |_| Factory.next(:name) }
  user.email        { |_| Factory.next(:email) }
end

Factory.define :credential do |c|
  c.provider    'OpenID'
  c.identifier  { |_| Factory.next(:openid_url) }
  c.user        { |_| User.first || Factory(:user) }
end

Factory.define :calendar do |calendar|
  calendar.title 'Quidditch Schedule'
  calendar.uri   'http://sports.yahoo.com/quidditch/flyers.ics'
  calendar.user  { |_| User.first || Factory(:user) }
end
