# frozen_string_literal: true

FactoryBot.define do
  factory :journey do
    title                   { FFaker::Name.name }
    description             { FFaker::Lorem.paragraph }
    start_plus_code         { FFaker::Random.rand }
    access_type             { :private_journey }
    accepts_recommendations { false }
    access_code             { nil }
    images                  { [Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg')] }
    passed_images_count     { 1 }

    user
  end
end
