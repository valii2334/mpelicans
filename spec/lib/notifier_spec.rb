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

      notification = user1.received_notifications.first

      expect(notification.sender).to eq(journey.user)
      expect(notification.receiver).to eq(user1)
      expect(notification.journey).to eq(journey)
      expect(notification).to be_new_journey

      notification = user2.received_notifications.first

      expect(notification.sender).to eq(journey.user)
      expect(notification.receiver).to eq(user2)
      expect(notification.journey).to eq(journey)
      expect(notification).to be_new_journey
    end
  end
end
