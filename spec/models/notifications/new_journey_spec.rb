# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::NewJourney, type: :model do
  include Rails.application.routes.url_helpers

  let(:notification) { build(:new_journey_notification) }
  subject { notification }

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :journey }

  ##################################
  # Methods
  ##################################

  context '#notification_title' do
    it 'returns notification title' do
      expect(subject.notification_title).to eq 'New journey created!'
    end
  end

  context '#notification_link' do
    it 'returns notification link' do
      expect(subject.notification_link).to eq journey_path(id: subject.journey.id)
    end
  end

  context '#notification_text' do
    it 'returns notification text' do
      expect(subject.notification_text).to eq(
        "#{subject.sender.username} created a new journey: #{subject.journey.title}."
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

    let(:notifier) { double('notifier') }

    before do
      allow(notifier)
        .to receive(:sender)
        .and_return(journey.user)
    end

    it 'returns receivers' do
      expect(Notifications::NewJourney.receivers(notifier:))
        .to match_array([user1, user2])
    end
  end
end
