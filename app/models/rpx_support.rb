module RpxSupport
  
  PARSE_RPX_DATA = lambda { |data|
    data = data['profile'].with_indifferent_access
    {
      :provider     => data[:providerName],
      :identifier   => data[:identifier],
      :email        => data[:verifiedEmail] || data[:email],
      :display_name => data[:displayName]   || (data[:name] || {})[:givenName],
    }.with_indifferent_access
  }
  
  # Find or create a User based on data returned from rpxnow.com.
  #
  # @param [Hash] data the Hash returned from rpxnow.com
  # @return [User] an existing or new User with at least one Credential
  def find_or_initialize_with_rpx(data)
    provider, identifier = data.delete(:provider), data.delete(:identifier)
    credential = Credential.find_by_provider_and_identifier(provider, identifier)
    user =  if credential
              credential.user.tap do |u|
                u.update_without_overwriting(data)
                u.save
              end
            else
              self.new(data) do |u|
                if u.save
                  u.credentials.create! :provider => provider, :identifier => identifier
                end
              end
            end
    user
  end
  
end
