# frozen_string_literal: true

FactoryBot.define do
  factory :journey_stop do
    description             { FFaker::Lorem.paragraph }
    images                  { [Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg')] }
    image_processing_status { :processed }
    lat                     { '46.749971' }
    long                    { '23.598739' }
    passed_images_count     { 1 }
    title                   { FFaker::Name.name }

    # rubocop:disable Style/SymbolProc
    after(:create) do |journey_stop|
      journey_stop.process_images
    end
    # rubocop:enable Style/SymbolProc

    journey
  end
end
