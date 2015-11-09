if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :authentication       => :plain,
    :user_name            => Rails.application.secrets.mailer_username,
    :password             => Rails.application.secrets.mailer_password,
    :domain               => 'gmail.com"',
    :enable_starttls_auto => true
  }
elsif Rails.env.development?
  ActionMailer::Base.default_url_options = { :host => 'localhost:7021' }
  ActionMailer::Base.smtp_settings = {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :authentication       => :plain,
    :user_name            => "hazius.pavel@gmail.com",
    :password             => "1234567vV",
    :domain               => "gmail.com",
    :enable_starttls_auto => true
  }
end
