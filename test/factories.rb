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

Factory.define :user do |user|
  user.display_name { Factory.next(:name) }
  user.username do |u|
    (u.display_name || '').match(/(\w)\w* (?:(\w)\. )?([\w']+)/)[1..-1].join.downcase
  end
  user.email do |u|
    "#{u.username || 'nobody'}@example.org"
  end
  user.password 'password'
  user.password_confirmation { |u| u.password }
end

Factory.define :calendar do |calendar|
  calendar.title 'Quidditch Schedule'
  calendar.uri   'http://sports.yahoo.com/quidditch/flyers.ics'
  calendar.user  { |_| User.first || Factory(:user) }
end
