# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotifierJob, type: :job do
  let(:journey_id)        { rand(1..99) }
  let(:notification_type) { FFaker::Lorem.word }
  let(:sender_id)         { rand(1..99) }

  let(:notifier)          { double('Notifier') }

  subject { described_class.new.perform(journey_id, notification_type, sender_id) }

  before do
    allow(Notifier).to receive(:new).with(journey_id:, notification_type: notification_type.to_sym,
                                          sender_id:).and_return(notifier)
    allow(notifier).to receive(:notify).and_return(true)
  end

  describe '#perform' do
    it 'calls notifier' do
      expect(Notifier).to receive(:new).with(journey_id:, notification_type: notification_type.to_sym,
                                             sender_id:).and_return(notifier)

      subject
    end
  end
end
