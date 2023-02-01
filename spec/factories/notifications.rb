# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    sendee            { create(:user) }
    sender            { create(:user) }
    notification_type { :bought_journey }
  end
end
