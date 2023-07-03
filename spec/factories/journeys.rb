# frozen_string_literal: true

require './spec/factory_bot_helper.rb'

FactoryBot.define do
  factory :journey do
    title { FFaker::Name.name }
    description             { FFaker::Lorem.paragraph }
    lat                     { '46.749971' }
    long                    { '23.598739' }
    access_type             { :private_journey }
    accepts_recommendations { false }
    access_code             { nil }
    image_processing_status { :processed }
    # images                  { [Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg')] }
    passed_images_count     { 1 }
    user

    after(:create) do |journey|
      allow(journey).to receive(:images_thumbnail_urls).and_return([])
      allow(journey).to receive(:images_max_urls).and_return([])
    end
  end
end
