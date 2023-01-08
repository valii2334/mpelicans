# frozen_string_literal: true

FactoryBot.define do
  factory :paid_journey do
    user
    journey
  end
end
