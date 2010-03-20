module RpxSupport
  
  PARSE_RPX_DATA = lambda { |data|
    data = (data['profile'] || {}).with_indifferent_access
    {
      :provider     => data[:providerName],
      :identifier   => data[:identifier],
      :email        => data[:verifiedEmail] || data[:email],
      :display_name => data[:displayName]   || (data[:name] || {})[:givenName],
    }.with_indifferent_access
  }
  
  def self.included(base)
    base.extend RpxSupport::ClassMethods
    base.send :include, RpxSupport::InstanceMethods
  end
  
  module ClassMethods
  
    # Build a new User based on data returned from rpxnow.com.
    #
    # @param [Hash] data the Hash returned from rpxnow.com (and already parsed via RpxSupport::PARSE_RPX_DATA)
    # @return [User, Credential] a new (unsaved) User and Credential.
    # @see RpxSupport::PARSE_RPX_DATA
    def build_from_rpx(data)
      data = data.dup
      provider, identifier = data.delete(:provider), data.delete(:identifier)
      user = self.new(data)
      credential = Credential.new(:provider => provider, :identifier => identifier, :user => user)
      return user, credential
    end
  
    # Find an existing User based on an existing Credential and update
    # the User based on data returned from rpxnow.com.
    #
    # @param [Hash] data the Hash returned from rpxnow.com (and already parsed via RpxSupport::PARSE_RPX_DATA)
    # @return [User] the User, possibly with (unsaved) updates.
    # @see RpxSupport::PARSE_RPX_DATA
    def find_and_update_from_rpx(data)
      data = data.dup
      provider, identifier = data.delete(:provider), data.delete(:identifier)
      credential = Credential.find_by_provider_and_identifier(provider, identifier)
      if credential
        credential.user.tap do |user|
          user.update_without_overwriting(data)
        end
      else
        nil
      end
    end
  
  end
  
  module InstanceMethods
    
    # Builds a new a Credential to the User from RPX data and updates any
    # user information. Will leave the User in an updated but unsaved state
    # if any user information is changed.
    #
    # @param [Hash] data the data returned from rpxnow.com (and already parsed via RpxSupport::PARSE_RPX_DATA)
    # @return [Credential] the new (unsaved) Credential
    # @see #update_without_overwriting
    def update_and_add_credential_from_rpx(data)
      data = data.dup
      provider, identifier = data.delete(:provider), data.delete(:identifier)
      self.update_without_overwriting(data)
      Credential.new(:provider => provider, :identifier => identifier, :user => self)
    end
    
    # Same as +update+, but won't overwrite non-blank values.
    #
    # @param [Hash] attrs new values
    def update_without_overwriting(attrs)
      attrs.each do |k,v|
        write_attribute(k,v) if read_attribute(k).blank?
      end
    end
    
  end

end