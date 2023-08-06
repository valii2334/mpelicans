# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifiers::BoughtJourney do
  let(:journey) { create :journey }
  let(:sender)  { create :user }

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
      end.to change { Notifications::BoughtJourney.count }.by(0)
    end
  end

  context 'journey is monetized' do
    before do
      journey.update(access_type: :monetized_journey)
    end

    it 'does send notifications' do
      expect do
        subject
      end.to change { Notifications::BoughtJourney.count }.by(1)
    end

    it 'creates notification with correct attributes', :aggregate_failures do
      subject

      notification = Notifications::BoughtJourney.last

      expect(notification.sender).to eq(sender)
      expect(notification.receiver).to eq(journey.user)
      expect(notification.journey).to eq(journey)
    end
  end
end
