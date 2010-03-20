class User < ActiveRecord::Base
  
  include  RpxSupport
  
  validates_presence_of   :email
  validates_uniqueness_of :email
  validates_format_of     :email,      :with => /^.*@.+\..+$/
  has_many :credentials#,               :autosave => true
  has_many :calendars
  
  def save_with_credential(credential)
    return false if credential.blank?
    transaction_error = false
    User.transaction do
      begin
        self.save!
        credential.user = self
        credential.save!
      rescue ActiveRecord::RecordInvalid => e  
        transaction_error = true
        if credential.errors.any?
          self.errors.add_to_base I18n.t('activerecord.errors.models.user.attributes.credential.blank')
        end
        raise ActiveRecord::Rollback
      end
    end
    !transaction_error
  end
  
  def has_credential_from?(provider)
    credentials.any? { |c| c.provider == Credential.normalize(provider) }
  end
  
  def to_s
    display_name.present? ? display_name : email
  end
  
  def aggregate_freebusy_calendar
    FreeBusyAggregate.new(*calendars_as_ri_cal_calendars).aggregate
  end
  
  # Same as +update+, but won't overwrite non-blank values.
  #
  # @param [Hash] attrs new values
  def update_without_overwriting(attrs)
    attrs.each do |k,v|
      write_attribute(k,v) if read_attribute(k).blank?
    end
  end
  
  protected
  
  def calendars_as_ri_cal_calendars  
    IcalRetriever.new.fetch_and_parse_all(self.calendars)
  end
  
end
