# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::BoughtJourney, type: :model do
  include Rails.application.routes.url_helpers

  let(:notification) { build(:bought_journey_notification) }
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
      expect(subject.notification_title).to eq 'Someone bought your journey!'
    end
  end

  context '#notification_link' do
    it 'returns notification link' do
      expect(subject.notification_link).to eq pelican_path(username: subject.sender.username)
    end
  end

  context '#notification_text' do
    it 'returns notification text' do
      expect(subject.notification_text).to eq(
        "#{subject.sender.username} just bought #{subject.journey.title}."
      )
    end
  end

  context '#receivers' do
    let(:notifier) { double('notifier') }
    let(:journey)  { create :journey }

    before do
      allow(notifier)
        .to receive(:journey)
        .and_return(journey)
    end

    it 'returns receivers' do
      expect(Notifications::BoughtJourney.receivers(notifier:))
        .to match_array([journey.user])
    end
  end
end
