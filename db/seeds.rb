# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

u = User.create(:email => 'james.a.rosen@gmail.com', :display_name => 'James Rosen')
Credential.create(:user => u, :provider => 'MyOpenID', :identifier => 'http://jamesarosen.com/')
