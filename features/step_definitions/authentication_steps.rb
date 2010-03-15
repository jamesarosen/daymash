Given /^I am signed in as ([^\"]+)$/ do |name|
  user = User.find_by_display_name(name) || Factory(:user, :display_name => name)
  sign_in_as user
end

Given /^I am (?:(?:not signed in)|(?:signed out))$/ do
  sign_in_as nil
end

Then "I should be sent to the RPX server" do
  Then "I should be redirected to /rpxnow\.com/"
end

module AuthenticationHelpers
  
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
