class Calendar < ActiveRecord::Base
  
  belongs_to :user, :touch => true
  validates_presence_of :uri, :title, :user
  validates_format_of :uri, :with => /^https?:\/\/.+\..+/
  validates_uniqueness_of :uri, :title, :scope => :user_id
  
end
