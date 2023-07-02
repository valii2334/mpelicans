# frozen_string_literal: true

FactoryBot.define do
  factory :journey do
    title                   { FFaker::Name.name }
    description             { FFaker::Lorem.paragraph }
    lat                     { '46.749971' }
    long                    { '23.598739' }
    access_type             { :private_journey }
    accepts_recommendations { false }
    access_code             { nil }
    image_processing_status { :processed }
    images                  { [Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg')] }
    passed_images_count     { 1 }
    user

    # rubocop:disable Style/SymbolProc
    after(:create) do |journey|
      journey.process_images
    end
    # rubocop:enable Style/SymbolProc
  end
end
