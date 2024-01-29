# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

gem 'rails', '~> 7.0.7.1'

gem 'async'
gem 'aws-sdk-s3'
gem 'barnes'
gem 'bootsnap', require: false
gem 'bootstrap5-kaminari-views'
gem 'browser', require: 'browser/browser'
gem 'cancancan'
gem 'cssbundling-rails'
gem 'devise'
gem 'faraday'
gem 'get_process_mem'
gem 'image_processing', '>= 1.2'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'kaminari'
gem 'pg', '~> 1.1'
gem 'puma', '>= 6.4.2'
gem 'redis', '~> 4.0'
gem 'rubocop-rails', require: false
gem 'sassc-rails'
gem 'scout_apm'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'sidekiq', '>= 7.1.3'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'stripe'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit',     require: false
  gem 'cypress-on-rails',  '~> 1.0'
  gem 'database_cleaner',  '~> 1.7.0'
  gem 'dotenv-rails',      '~>2.7.6', require: 'dotenv/rails-now'
  gem 'factory_bot_rails', '~> 5.1.1'
  gem 'ffaker',            '~> 2.15.0'
  gem 'pry'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 5.0.0'
  gem 'rubocop'
  gem 'shoulda-matchers', '~> 4.1'
  gem 'simplecov'
  gem 'webmock'
end

group :development do
  gem 'web-console'
end
