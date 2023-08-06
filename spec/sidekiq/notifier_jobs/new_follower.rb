# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifierJobs::NewFollower, type: :job do
  let(:receiver_id) { rand(1..99) }
  let(:sender_id)   { rand(1..99) }
  let(:notifier)    { double('Notifier') }

  subject { described_class.new.perform(sender_id, receiver_id) }

  before do
    allow(Notifiers::NewFollower)
      .to receive(:new)
      .with(receiver_id:, sender_id:)
      .and_return(notifier)

    allow(notifier)
      .to receive(:notify)
      .and_return(true)
  end

  describe '#perform' do
    it 'calls notifier' do
      expect(Notifiers::NewFollower)
        .to receive(:new)
        .with(receiver_id:, sender_id:)
        .and_return(notifier)

      subject
    end
  end
end
