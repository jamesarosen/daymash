Given /^I am signed in as (.+)(?: via (.+))?$/ do |name, possibly_a_provider|
  user = user_from_name(name)
  if possibly_a_provider
    Given "#{name} has registered a credential from #{possibly_a_provider}"
  end
  sign_in_as user
end

Given /^(.+) has registered a credential from ([^\"]+)$/ do |name, provider|
  user = user_from_name(name)
  unless user.has_credential_from?(provider)
    Factory(:credential, :user => user, :provider => provider)
  end
end

Given /^I am (?:(?:not signed in)|(?:signed out))$/ do
  sign_in_as nil
end

Then "I should be sent to the RPX server" do
  Then "I should be redirected to /rpxnow\.com/"
end

module AuthenticationHelpers
  
  def user_from_name(name)
    User.find_by_display_name(name) || Factory(:user, :display_name => name)
  end
  
  def current_user
    @current_user
  end
  
  def sign_in_as user
    return if @current_user == user
    @current_user = user
    if user.nil?
      get '/sign_out'
    else
      get '/', {'current_user_id' => user.to_param}
    end
  end
  
  def signed_in_as(user, &block)
    previous_user = @current_user
    begin
      sign_in_as user
      block.call
    ensure
      sign_in_as previous_user
    end
  end
  
end

World(AuthenticationHelpers)
