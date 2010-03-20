# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

u = User.create(:email => 'james.a.rosen@gmail.com', :display_name => 'James Rosen')
Credential.create :user => u, :provider => 'MyOpenID', :identifier => 'http://jamesarosen.com/'
Credential.create :user => u, :provider => 'Twitter',  :identifier => 'http://twitter.com/account/profile?user_id=7114202'
Credential.create :user => u, :provider => 'Facebook', :identifier => 'http://www.facebook.com/profile.php?id=3102254'
Credential.create :user => u, :provider => 'Google',   :identifier => 'https://www.google.com/accounts/o8/id?id=AItOawmS8cYL_iLLHYXSUTCu5gfzDlaqeDHA294'
