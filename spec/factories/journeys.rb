# frozen_string_literal: true

FactoryBot.define do
  factory :journey do
    title                   { FFaker::Name.name }
    description             { FFaker::Lorem.paragraph }
    start_plus_code         { FFaker::Random.rand }
    status                  { :not_started }
    access_type             { :private_journey }
    accepts_recommendations { false }
    access_code             { nil }
    image                   { Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg') }

    user
  end
end
