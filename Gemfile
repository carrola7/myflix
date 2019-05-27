source 'https://rubygems.org'
ruby '2.3.1'

gem 'bootstrap-sass', '3.1.1.1'
gem 'coffee-rails'
gem 'rails', '4.1.2'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg', '~> 0.11'
gem 'bcrypt-ruby', '~> 3.1.2' 
gem 'bootstrap_form'
gem 'rake', '< 11.0'
gem 'sidekiq', '~> 4.0'
gem 'unicorn'
gem "sentry-raven"
gem 'carrierwave', '~> 1.0'
gem 'mini_magick'
gem 'fog-aws'
gem 'stripe'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
  gem 'faker'
end

group :test do
  gem 'database_cleaner', '1.4.1'
  gem 'shoulda-matchers', '2.7.0'
  gem 'vcr', '2.9.3'
  gem 'webmock'
  gem 'fabrication'
  gem 'capybara'
  gem 'capybara-email'
  gem 'selenium-webdriver'
  gem 'geckodriver-helper'
end

group :production do
  gem 'rails_12factor'
end

