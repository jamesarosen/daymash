class User < ActiveRecord::Base
  
  extend  RpxSupport
  
  validates_presence_of   :email
  validates_format_of     :email,      :with => /^.*@.+\..+$/
  has_many :credentials
  has_many :calendars
  
  def to_s
    display_name.present? ? display_name : email
  end
  
  def aggregate_freebusy_calendar
    FreeBusyAggregate.new(*calendars_as_ri_cal_calendars).aggregate
  end
  
  protected
  
  def calendars_as_ri_cal_calendars  
    IcalRetriever.new.fetch_and_parse_all(self.calendars)
  end
  
end
