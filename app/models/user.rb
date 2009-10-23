class User < ActiveRecord::Base
  
  acts_as_authentic
  has_many :calendars
  
  def self.find_by_username_or_email(username_or_email)
    self.find(:first, :conditions => [
      "username = ? OR email = ?", username_or_email, username_or_email
    ])
  end
  
  def to_s
    display_name.present? ? display_name : username
  end
  
  def aggregate_freebusy_calendar
    FreeBusyAggregate.new(*calendars_as_ri_cal_calendars).aggregate
  end
  
  protected
  
  def calendars_as_ri_cal_calendars  
    IcalRetriever.new.fetch_and_parse_all(self.calendars)
  end
  
end
