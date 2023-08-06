# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::NewFollower, type: :model do
  include Rails.application.routes.url_helpers

  let(:notification) { build(:new_follower_notification) }
  subject { notification }

  ##################################
  # Methods
  ##################################

  context '#notification_title' do
    it 'returns notification title' do
      expect(subject.notification_title).to eq 'You have a new follower!'
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
        "#{subject.sender.username} is now following you."
      )
    end
  end

  context '#receivers' do
    let(:notifier) { double('notifier') }
    let(:receiver) { create :user }

    before do
      allow(notifier)
        .to receive(:receiver)
        .and_return(receiver)
    end

    it 'returns receivers' do
      expect(Notifications::NewFollower.receivers(notifier:))
        .to match_array([receiver])
    end
  end

  context '#should_notify?' do
    let(:notifier) { double('notifier') }

    it 'returns true' do
      expect(described_class.should_notify?(notifier:)).to be_truthy
    end
  end
end
