AaaStriping::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # When false, gives us just an application.js/.css  When true it expands them all out
  config.assets.debug = true

  # Enables the use of MD5 fingerprints in asset names.  Makes versioned .css/.js work
  # Must be FALSE in Development mode
  config.assets.digest = false

  # This gives us the Called id for nil, which would mistakenly be 4 message.  This will be deprecated soon.
  config.whiny_nils = true

  # Provides additional information in stack traces
  config.consider_all_requests_local = true

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = true

  # Reload application code on every request
  config.cache_classes = false

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # E-mail
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger.const_get(ENV['LOG_LEVEL'] ? ENV['LOG_LEVEL'].upcase : 'DEBUG')

  # Paperclip config
  config.paperclip_defaults = {
      :storage => :s3,
      :s3_credentials => {
          :bucket => ENV['S3_BUCKET_NAME'],
          :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
          :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
          :region => 'oregon'
      },
      :s3_host_name => 's3-us-west-2.amazonaws.com'
  }
end
