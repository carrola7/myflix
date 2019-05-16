CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_provider = 'fog/aws'                        # required
    config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],                        # required unless using use_iam_profile
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],                        # required unless using use_iam_profile
      # use_iam_profile:       true,                         # optional, defaults to false
      # region:                'eu-west-1',                  # optional, defaults to 'us-east-1'
      # host:                  's3.example.com',             # optional, defaults to nil
      # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
    }
    config.fog_directory  = 'myflix-storage'                                      # required
    
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
