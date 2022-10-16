# frozen_string_literal: true

FactoryBot.define do
  factory :journey_stop do
    title       { FFaker::Name.name }
    description { FFaker::Lorem.paragraph }
    plus_code   { FFaker::Random.rand }
    images      { [Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg')] }

    journey
  end
end
