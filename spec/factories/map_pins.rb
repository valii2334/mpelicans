# frozen_string_literal: true

FactoryBot.define do
  factory :map_pin do
    lat   { 46.749971 }
    long  { 23.598739 }
    title { FFaker::Name.name }

    journey_stop
    user
  end
end
