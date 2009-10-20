# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_less_scheduling_session',
  :secret      => '198e25974beb362b827f3553f354165ae3ccb8a76a1d364c09cd0a5e599514bd887162aaea8a24948485dfc3c6062256e48ef7f2d91860d5c73e949efbe5397f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
