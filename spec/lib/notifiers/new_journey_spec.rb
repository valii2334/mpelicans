# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifiers::NewJourney do
  let(:user1) { create :user }
  let(:user2) { create :user }
  let(:user3) { create :user }

  let(:journey) { create :journey }
  let(:sender)  { journey.user }

  let!(:follower1) { create(:relationship, follower: user1,        followee: journey.user) }
  let!(:follower2) { create(:relationship, follower: user2,        followee: journey.user) }
  let!(:followee)  { create(:relationship, follower: journey.user, followee: user3) }

  subject do
    described_class
      .new(
        journey_id: journey.id,
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
      end.to change { Notifications::NewJourney.count }.by(0)
    end
  end

  context 'journey is monetized' do
    before do
      journey.update(access_type: :monetized_journey)
    end

    it 'does send notifications' do
      expect do
        subject
      end.to change { Notifications::NewJourney.count }.by(2)
    end

    it 'creates notification with correct attributes', :aggregate_failures do
      subject

      notifications = Notifications::NewJourney.all

      notification = notifications.find { |n| n.receiver == user1 }
      expect(notification.sender).to eq(sender)
      expect(notification.journey).to eq(journey)

      notification = notifications.find { |n| n.receiver == user2 }
      expect(notification.sender).to eq(sender)
      expect(notification.journey).to eq(journey)
    end
  end
end
