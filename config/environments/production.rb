AaaStriping::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  ########################
  ## Heroku Integration
  ########################

  config.log_level = :debug

  config.action_mailer.default_url_options = { :host => "www.zebraonline.ca" }

  config.middleware.use ExceptionNotifier,
    :email_prefix => "[AAAS] ",
    :sender_address => %{"AAAS" <error@aaastriping.com>},
    :exception_recipients => %w{errors@agilestyle.com}

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
