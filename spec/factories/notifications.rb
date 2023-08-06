# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    sender   { create(:user) }
    receiver { create(:user) }
  end

  factory :bought_journey_notification, class: Notifications::BoughtJourney, parent: :notification do
    journey { create(:journey) }
  end

  factory :new_journey_notification, class: Notifications::NewJourney, parent: :notification do
    journey { create(:journey) }
  end

  factory :new_journey_stop_notification, class: Notifications::NewJourneyStop, parent: :notification do
    journey { create(:journey) }
    journey_stop { create(:journey_stop) }
  end

  # rubocop:disable Lint/EmptyBlock
  factory :new_follower_notification, class: Notifications::NewFollower, parent: :notification do
  end
  # rubocop:enable Lint/EmptyBlock
end
