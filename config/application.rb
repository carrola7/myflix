require File.expand_path('../boot', __FILE__)

require 'rails/all'
# require 'carrierwave'
#require 'carrierwave/orm/activerecord'

Bundler.require(:default, Rails.env)

Raven.configure do |config|
  config.dsn = 'https://a32eec24dea249aaa8a4d8dc98d57872:926668dfefca40909eb8b8b4b88ec589@sentry.io/1454849'
end

module Myflix
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true
    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
    end
    config.autoload_paths << "#{Rails.root}/lib/"
  end
end
