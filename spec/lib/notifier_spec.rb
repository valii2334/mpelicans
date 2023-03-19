# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifier do
  let(:journey) { create :journey }
  let(:sender)  { create :user }

  context '#bought_journey' do
    let(:notification_type) { :bought_journey }

    subject do
      Notifier.new(journey_id: journey.id, notification_type:, sender_id: sender.id).notify
    end

    it 'creates one notification for the journey creator', aggregate: :failures do
      expect do
        subject
      end.to change { Notification.count }.by(1)

      notification = Notification.last

      expect(notification.sender).to eq(sender)
      expect(notification.receiver).to eq(journey.user)
      expect(notification.journey).to eq(journey)
      expect(notification).to be_bought_journey
    end
  end

  context '#new_journey' do
    let(:notification_type) { :new_journey }

    let(:user1) { create :user }
    let(:user2) { create :user }
    let(:user3) { create :user }

    let!(:follower1) { create(:relationship, follower: user1,        followee: journey.user) }
    let!(:follower2) { create(:relationship, follower: user2,        followee: journey.user) }
    let!(:followee)  { create(:relationship, follower: journey.user, followee: user3) }

    subject do
      Notifier.new(journey_id: journey.id, notification_type:, sender_id: journey.user.id).notify
    end

    it 'creates one notification for each follower', aggregate: :failures do
      expect do
        subject
      end.to change { Notification.count }.by(2)

      [user1, user2].each do |user|
        notification = user.received_notifications.first

        expect(notification.sender).to eq(journey.user)
        expect(notification.receiver).to eq(user)
        expect(notification.journey).to eq(journey)
        expect(notification).to be_new_journey
      end
    end
  end

  context '#new_journey_stop' do
    let(:notification_type) { :new_journey_stop }

    let(:user1) { create :user }
    let(:user2) { create :user }
    let(:user3) { create :user }

    let!(:follower1) { create(:relationship, follower: user1,        followee: journey.user) }
    let!(:follower2) { create(:relationship, follower: user2,        followee: journey.user) }
    let!(:followee)  { create(:relationship, follower: journey.user, followee: user3) }

    # user3 does not follow journey.user but purchased this journey
    let!(:paid_journey) { create(:paid_journey, user: user3, journey:) }

    # last journey stop in order to be able to create the notification
    let!(:journey_stop) { create(:journey_stop, journey:) }

    subject do
      Notifier.new(journey_id: journey.id, notification_type:, sender_id: journey.user.id).notify
    end

    it 'creates one notification for each follower and paying journey user' do
      expect do
        subject
      end.to change { Notification.count }.by(3)

      [user1, user2, user3].each do |user|
        notification = user.received_notifications.first

        expect(notification.sender).to eq(journey.user)
        expect(notification.receiver).to eq(user)
        expect(notification.journey).to eq(journey)
        expect(notification).to be_new_journey_stop
      end
    end
  end

  context '#random_notification_type' do
    let(:notification_type) { :random_notification_type }

    subject do
      Notifier.new(journey_id: journey.id, notification_type:, sender_id: journey.user.id).notify
    end

    it 'raises an error' do
      expect do
        subject
      end.to raise_error(StandardError)
    end
  end
end