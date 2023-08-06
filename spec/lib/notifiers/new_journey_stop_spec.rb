# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifiers::NewJourneyStop do
  let(:user1) { create :user }
  let(:user2) { create :user }
  let(:user3) { create :user }

  let(:journey) { create :journey }
  let(:sender)  { journey.user }

  let!(:follower1) { create(:relationship, follower: user1,        followee: journey.user) }
  let!(:follower2) { create(:relationship, follower: user2,        followee: journey.user) }
  let!(:followee)  { create(:relationship, follower: journey.user, followee: user3) }

  # user3 does not follow journey.user but purchased this journey
  let!(:paid_journey) { create(:paid_journey, user: user3, journey:) }

  # last journey stop in order to be able to create the notification
  let!(:journey_stop) { create(:journey_stop, journey:) }

  subject do
    described_class
      .new(
        journey_id: journey.id,
        journey_stop_id: journey_stop.id,
        sender_id: sender.id
      )
      .notify
  end

  context 'journey is not monetized' do
    before do
      journey.update(access_type: :private_journey)
    end

    it 'does not send any notifications' do
      expect do
        subject
      end.to change { Notifications::NewJourneyStop.count }.by(0)
    end
  end

  context 'journey is monetized' do
    before do
      journey.update(access_type: :monetized_journey)
    end

    it 'does send notifications' do
      expect do
        subject
      end.to change { Notifications::NewJourneyStop.count }.by(3)
    end

    it 'creates notification with correct attributes', :aggregate_failures do
      subject

      notifications = Notifications::NewJourneyStop.all

      notification = notifications.find { |n| n.receiver == user1 }
      expect(notification.sender).to eq(sender)
      expect(notification.journey).to eq(journey)
      expect(notification.journey_stop).to eq(journey_stop)

      notification = notifications.find { |n| n.receiver == user2 }
      expect(notification.sender).to eq(sender)
      expect(notification.journey).to eq(journey)
      expect(notification.journey_stop).to eq(journey_stop)

      notification = notifications.find { |n| n.receiver == user3 }
      expect(notification.sender).to eq(sender)
      expect(notification.journey).to eq(journey)
      expect(notification.journey_stop).to eq(journey_stop)
    end
  end
end
