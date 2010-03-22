require 'digest/sha2'

class User < ActiveRecord::Base
  
  include  RpxSupport
  
  validates_presence_of   :email
  validates_uniqueness_of :email
  validates_format_of     :email,         :with => /^.*@.+\..+$/,        :allow_blank => true
  validates_presence_of   :privacy_token
  validates_format_of     :privacy_token, :with => /^[A-Za-z0-9]{24,}$/, :allow_blank => true
  has_many :credentials
  has_many :calendars
  
  before_validation :set_privacy_token_if_needed
  
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
  
  # Generates a new privacy token and tries to save the User.
  #
  # @return [true, false] whether the update was successful
  def reset_privacy_token
    self.privacy_token = generate_privacy_token
    save
  end
  
  protected
  
  def calendars_as_ri_cal_calendars  
    IcalRetriever.new.fetch_and_parse_all(self.calendars)
  end
  
  def set_privacy_token_if_needed
    self.privacy_token ||= generate_privacy_token
  end
  
  def generate_privacy_token
    Digest::SHA2.new.tap do |digest|
      digest << "This is one heck of a random secret string, isn't it?"
      digest << Time.now.to_s
      digest << self.email if self.email.present?
      digest << self.display_name if self.display_name.present?
      digest << self.privacy_token if self.privacy_token.present?
    end.to_s[0..24]
  end
  
end
