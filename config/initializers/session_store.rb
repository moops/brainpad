# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_brainpad_session',
  :secret      => 'f607fdb86c454ae492eee486995fe3bec8422776ef261207f4c210f70730aa4ffa810f37ace135f15ecfffb868b8e38101925d0c838ae0aca5b5f356e052c7ba'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
