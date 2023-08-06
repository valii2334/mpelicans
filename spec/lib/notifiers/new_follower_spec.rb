# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifiers::NewFollower do
  let(:sender)   { create :user }
  let(:receiver) { create :user }

  subject do
    described_class
      .new(
        sender_id: sender.id,
        receiver_id: receiver.id
      )
      .notify
  end

  it 'does send notifications' do
    expect do
      subject
    end.to change { Notifications::NewFollower.count }.by(1)
  end

  it 'creates notification with correct attributes', :aggregate_failures do
    subject

    notification = Notifications::NewFollower.last

    expect(notification.sender).to eq(sender)
    expect(notification.receiver).to eq(receiver)
  end
end
