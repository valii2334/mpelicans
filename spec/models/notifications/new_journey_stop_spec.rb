# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::NewJourneyStop, type: :model do
  include Rails.application.routes.url_helpers

  let(:notification) { build(:new_journey_stop_notification) }
  subject { notification }

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :journey }
  it { should validate_presence_of :journey_stop }

  ##################################
  # Methods
  ##################################

  context '#notification_title' do
    it 'returns notification title' do
      expect(subject.notification_title).to eq 'New journey stop added!'
    end
  end

  context '#notification_link' do
    it 'returns notification link' do
      expect(subject.notification_link).to eq journey_journey_stop_path(
        journey_id: subject.journey_stop.journey.id, id: subject.journey_stop.id
      )
    end
  end

  context '#notification_text' do
    it 'returns notification text' do
      expect(subject.notification_text).to eq(
        "#{subject.sender.username} added a new stop to #{subject.journey.title}."
      )
    end
  end

  context '#receivers' do
    let(:user1) { create :user }
    let(:user2) { create :user }
    let(:user3) { create :user }

    let(:journey) { create :journey }

    let!(:follower1) { create(:relationship, follower: user1,        followee: journey.user) }
    let!(:follower2) { create(:relationship, follower: user2,        followee: journey.user) }
    let!(:followee)  { create(:relationship, follower: journey.user, followee: user3) }

    # user3 does not follow journey.user but purchased this journey
    let!(:paid_journey) { create(:paid_journey, user: user3, journey:) }

    # last journey stop in order to be able to create the notification
    let!(:journey_stop) { create(:journey_stop, journey:) }

    let(:notifier) { double('notifier') }

    before do
      allow(notifier)
        .to receive(:sender)
        .and_return(journey.user)

      allow(notifier)
        .to receive(:journey)
        .and_return(journey)
    end

    it 'returns receivers' do
      expect(Notifications::NewJourneyStop.receivers(notifier:))
        .to match_array([user1, user2, user3])
    end
  end
end
