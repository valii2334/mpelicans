# frozen_string_literal: true

require './spec/factory_bot_helper.rb'

FactoryBot.define do
  factory :journey_stop do
    description { FFaker::Lorem.paragraph }
    # images                  { [Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg')] }
    image_processing_status { :processed }
    lat                     { '46.749971' }
    long                    { '23.598739' }
    passed_images_count     { 1 }
    title                   { FFaker::Name.name }

    journey

    after(:create) do |journey_stop|
      allow(journey_stop).to receive(:images_thumbnail_urls).and_return([])
      allow(journey_stop).to receive(:images_max_urls).and_return([])
    end
  end
end
