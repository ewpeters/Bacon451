# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Bacon451_session',
  :secret      => 'f7dcde270adb08465c0da483ed1cca45a7ab43e8fe80b741fecc69ba2f1f78c7d4eebf02a50c3df55839e6783569d8bc0b5b57293596559c61681cfb3acf1728'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
