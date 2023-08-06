# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifierJobs::BoughtJourney, type: :job do
  let(:journey_id) { rand(1..99) }
  let(:sender_id)  { rand(1..99) }
  let(:notifier)   { double('Notifier') }

  subject { described_class.new.perform(journey_id, sender_id) }

  before do
    allow(Notifiers::BoughtJourney)
      .to receive(:new)
      .with(journey_id:, sender_id:)
      .and_return(notifier)

    allow(notifier)
      .to receive(:notify)
      .and_return(true)
  end

  describe '#perform' do
    it 'calls notifier' do
      expect(Notifiers::BoughtJourney)
        .to receive(:new)
        .with(journey_id:, sender_id:)
        .and_return(notifier)

      subject
    end
  end
end
