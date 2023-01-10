# frozen_string_literal: true

# cleaning the database using database_cleaner
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

if defined?(VCR)
  VCR.eject_cassette # make sure we no cassette inserted before the next test starts
  VCR.turn_off!
  WebMock.disable! if defined?(WebMock)
end

ActionMailer::Base.deliveries.clear
