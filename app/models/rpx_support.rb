module RpxSupport
  
  # Find or create a User based on data returned from rpxnow.com.
  #
  # @param [Hash] data the Hash returned from rpxnow.com
  # @return [User] an existing or new User with at least one Credential
  def find_or_initialize_with_rpx(data)
    data = data.with_indifferent_access
    provider, identifier = data[:providerName], data[:identifier]
    credential = Credential.find_by_provider_and_identifier(provider, identifier)
    user =  if credential
              credential.user.tap do |u|
                u.update!(parse_rpx_hash(data))
              end
            else
              self.new(parse_rpx_hash(data)) do |u|
                u.save!
                u.credentials.create! :provider => provider, :identifier => identifier
              end
            end
    user
  end
  
  # Translates the +Hash+ returned from rpxnow.com into
  # a +Hash+ usable by the +User+ class.
  #
  # @param [Hash] data Hash returned from rpxnow.com
  # @return [Hash] a more ActiveRecord-y Hash
  def parse_rpx_hash(data)
    {
      :email        => data[:verifiedEmail] || data[:email],
      :display_name => data[:displayName]   || (data[:name] || {})[:givenName],
    }
  end
  
end
