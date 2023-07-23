# frozen_string_literal: true

require './spec/factory_bot_helper'

FactoryBot.define do
  factory :journey_stop do
    description             { FFaker::Lorem.paragraph }
    image_processing_status { :processed }
    lat                     { 46.749971 }
    long                    { 23.598739 }
    passed_images_count     { 1 }
    title                   { FFaker::Name.name }

    journey

    after(:create) do |journey_stop|
      allow(journey_stop).to receive(:images_urls).with(variant: :max).and_return([])
      allow(journey_stop).to receive(:images_urls).with(variant: :thumbnail).and_return([])
    end
  end
end
