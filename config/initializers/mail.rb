ActionMailer::Base.smtp_settings = {
  :port =>           '587',
  :address =>        'smtp.mandrillapp.com',
  :user_name =>      ENV['MANDRILL_USERNAME'],
  :password =>       ENV['MANDRILL_APIKEY'],
  :domain =>         'heroku.com',
  :authentication => :plain
}
ActionMailer::Base.delivery_method = :smtp

# Settings for MailCatcher in development mode
# http://mailcatcher.me/
if Rails.env.development?
  ActionMailer::Base.smtp_settings = { :address => "localhost", :port => 1025 }
end
