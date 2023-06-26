# frozen_string_literal: true

FactoryBot.define do
  factory :uploaded_image do
    s3_key { FFaker::Name.name }
  end
end
