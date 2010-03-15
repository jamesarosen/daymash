class Credential < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of   :user, :provider, :identifier
  validates_uniqueness_of :identifier, :scope => [:provider]
  
  before_save :normalize_provider_and_identifier
  
  def self.find_by_provider_and_identifier(provider, identifier)
    return nil if provider.blank? or identifier.blank?
    find(:first, :conditions => { :provider => provider.to_s.downcase,
                                  :identifier => identifier.to_s.downcase })
  end
  
  def to_s
    identifier
  end
  
  def to_param
    "#{id}-#{provider}"
  end
  
  protected
  
  def normalize_provider_and_identifier
    self.provider   &&= provider.downcase
    self.identifier &&= identifier.downcase
  end
  
end
