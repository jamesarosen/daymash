class Credential < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of   :user, :provider, :identifier
  validates_uniqueness_of :identifier, :scope => [:provider]
  
  before_save :normalize_provider_and_identifier
  
  def self.find_by_provider_and_identifier(provider, identifier)
    return nil if provider.blank? or identifier.blank?
    find(:first, :conditions => { :provider => normalize(provider),
                                  :identifier => normalize(identifier) })
  end
  
  # Normalizes (currently, to_s.downcase, though that is not specified)
  # the given provider or identifier.
  #
  # @param [Sting, Symbol] provider_or_identifier
  def self.normalize(provider_or_identifier)
    provider_or_identifier.to_s.downcase
  end
  
  def to_s
    identifier
  end
  
  def to_param
    "#{id}-#{provider}"
  end
  
  protected
  
  def normalize_provider_and_identifier
    self.provider   &&= self.class.normalize(provider)
    self.identifier &&= self.class.normalize(identifier)
  end
  
end
