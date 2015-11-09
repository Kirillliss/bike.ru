CarrierWave.configure do |config|
  config.storage = Rails.env.production? ? :fog : :file
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Rails.application.secrets.aws_access_key_id,
    aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
    region: 'eu-central-1',
    path_style: true
  }
  config.fog_directory  = Rails.application.secrets.s3_bucket
end
