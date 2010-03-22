class Credential < ActiveRecord::Base
  
  acts_as_archive
  belongs_to :user
  
  validates_presence_of   :user, :provider, :identifier
  validates_uniqueness_of :identifier, :scope => [:provider]
  
  before_save :normalize_provider_and_identifier
  
  def self.find_by_provider_and_identifier(provider, identifier)
    return nil if provider.blank? or identifier.blank?
    find(:first, :conditions => { :provider => normalize(provider),
                                  :identifier => normalize(identifier) })
  end
  
  # Normalizes (currently, just to_s, though that is not specified)
  # the given provider or identifier.
  #
  # @param [Sting, Symbol] provider_or_identifier
  # @return [String] the normalized provider or identifier
  def self.normalize(provider_or_identifier)
    provider_or_identifier.to_s
  end
  
  def to_s
    identifier
  end
  
  def to_param
    "#{id}-#{provider}"
  end
  
  def last_credential_for_user?
    self.user.credentials.none? { |c| c != self }
  end
  
  protected
  
  def normalize_provider_and_identifier
    self.provider   &&= self.class.normalize(provider)
    self.identifier &&= self.class.normalize(identifier)
  end
  
end

Credential::Archive.class_eval do
  
  # Finds a deleted Credential for the given user with the given ID.
  #
  # @param [User] user
  # @param [Fixnum] id
  # @return [Credential::Archive] a deleted credential
  # @raise [ActiveRecord::RecordNotFound] if user has no such deleted credential
  def self.find_by_user_and_id!(user, id)
    returning(find_by_user_id_and_id(user, id.to_i)) do |c|
      raise ActiveRecord::RecordNotFound.new("User ##{user_id} has no deleted credential ##{id}") unless c
    end
  end
  
  def restore
    Credential.restore_all(['id = ?', id])
    Credential.find(id)
  end
end
