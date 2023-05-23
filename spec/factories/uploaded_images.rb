FactoryBot.define do
  factory :uploaded_image do
    s3_key { FFaker::Name.name }

    journey_stop
  end
end
