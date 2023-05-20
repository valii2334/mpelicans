# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifier do
  let(:journey) { create :journey, access_type: }
  let(:sender)  { create :user }

  context 'public_journey' do
    let(:access_type) { :public_journey }

    context '#bought_journey' do
      include_context 'bought_journey set up'

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
      include_context 'new_journey set up'

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
      include_context 'new_journey_stop set up'

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

  context 'other access type' do
    let(:access_type) { :private_journey }

    context '#bought_journey' do
      include_context 'bought_journey set up'

      it 'does not create any notifications' do
        expect { subject }.to change { Notification.count }.by(0)
      end
    end

    context '#new_journey' do
      include_context 'new_journey set up'

      it 'does not create any notifications' do
        expect { subject }.to change { Notification.count }.by(0)
      end
    end

    context '#new_journey_stop' do
      include_context 'new_journey_stop set up'

      it 'does not create any notifications' do
        expect { subject }.to change { Notification.count }.by(0)
      end
    end
  end
end
