source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

gem 'rails', '~> 7.0.3', '>= 7.0.3.1'

gem 'aws-sdk-s3', require: false
gem 'bootsnap', require: false
gem 'cancancan'
gem 'cssbundling-rails'
gem 'devise'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'image_processing', '>= 1.2'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'redis', '~> 4.0'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem 'database_cleaner',  '~> 1.7.0'
  gem 'dotenv-rails',      '~>2.7.6', require: 'dotenv/rails-now'
  gem 'factory_bot_rails', '~> 5.1.1'
  gem 'ffaker',            '~> 2.15.0'
  gem 'pry'
  gem 'rspec-rails',       '~> 5.0.0'
  gem 'shoulda-matchers',  '~> 4.1'
  gem 'simplecov'
end

group :development do
  gem 'web-console'
end
