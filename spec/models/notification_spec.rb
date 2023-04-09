# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  include Rails.application.routes.url_helpers

  let(:notification) { build(:notification) }
  subject { notification }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :sender_id }
  it { should have_attribute :read }
  it { should have_attribute :receiver_id }
  it { should have_attribute :notification_type }
  it { should have_attribute :journey_id }
  it { should have_attribute :journey_stop_id }

  it {
    should define_enum_for(:notification_type).with_values(
      %i[bought_journey new_journey new_journey_stop]
    )
  }

  ##################################
  # Associations
  ##################################

  it { should belong_to(:sender).class_name('User') }
  it { should belong_to(:receiver).class_name('User') }
  it { should belong_to(:journey) }
  it { should belong_to(:journey_stop).optional(true) }

  ##################################
  # Validations
  ##################################

  context '#journey_stop' do
    let(:notification) { build(:notification, notification_type: :new_journey_stop, journey_stop:) }

    context 'missing journey_stop' do
      let(:journey_stop) { nil }

      it 'is not valid' do
        expect(notification).to_not be_valid
      end
    end

    context 'has journey_stop' do
      let(:journey_stop) { create(:journey_stop) }

      it 'is not valid' do
        expect(notification).to be_valid
      end
    end
  end

  ##################################
  # Methods
  ##################################

  context '#notification_title' do
    let(:journey_stop) { create(:journey_stop) }
    let(:notification) { build(:notification, notification_type:, journey_stop:) }

    context 'bought_journey' do
      let(:notification_type) { :bought_journey }

      it 'returns notification title' do
        expect(notification.notification_title).to eq 'Someone bought your journey!'
      end
    end

    context 'new_journey' do
      let(:notification_type) { :new_journey }

      it 'returns notification title' do
        expect(notification.notification_title).to eq 'New journey created!'
      end
    end

    context 'new_journey_stop' do
      let(:notification_type) { :new_journey_stop }

      it 'returns notification title' do
        expect(notification.notification_title).to eq 'New journey stop added!'
      end
    end
  end

  context '#notification_link' do
    let(:journey_stop) { create(:journey_stop) }
    let(:notification) do
      build(
        :notification,
        notification_type:,
        journey: journey_stop.journey,
        journey_stop:
      )
    end

    context 'bought_journey' do
      let(:notification_type) { :bought_journey }

      it 'returns notification link' do
        expect(notification.notification_link).to eq pelican_path(username: notification.sender.username)
      end
    end

    context 'new_journey' do
      let(:notification_type) { :new_journey }

      it 'returns notification link' do
        expect(notification.notification_link).to eq journey_path(id: notification.journey.id)
      end
    end

    context 'new_journey_stop' do
      let(:notification_type) { :new_journey_stop }

      it 'returns notification link' do
        expect(notification.notification_link).to eq journey_journey_stop_path(
          journey_id: notification.journey_stop.journey.id, id: notification.journey_stop.id
        )
      end
    end
  end

  context '#notification_text' do
    let(:notification) { build(:notification, notification_type:) }

    context 'bought_journey' do
      let(:notification_type) { :bought_journey }

      it 'returns notification text' do
        expect(notification.notification_text).to eq(
          "#{notification.sender.username} just bought #{notification.journey.title}."
        )
      end
    end

    context 'new_journey' do
      let(:notification_type) { :new_journey }

      it 'returns notification text' do
        expect(notification.notification_text).to eq(
          "#{notification.sender.username} created a new journey: #{notification.journey.title}."
        )
      end
    end

    context 'new_journey_stop' do
      let(:notification_type) { :new_journey_stop }

      it 'returns notification text' do
        expect(notification.notification_text).to eq(
          "#{notification.sender.username} added a new stop to #{notification.journey.title}."
        )
      end
    end
  end
end
