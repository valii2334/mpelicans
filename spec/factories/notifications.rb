# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    sender            { create(:user) }
    receiver          { create(:user) }
    notification_type { :bought_journey }

    journey
  end
end
