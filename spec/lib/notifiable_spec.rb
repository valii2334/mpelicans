# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifiable do
  context '#journey_notification' do
    subject do
      described_class.journey_notification(journey:)
    end

    context 'public journey' do
      let(:journey) { create :journey, access_type: :public_journey }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'monetized journey' do
      let(:journey) { create :journey, access_type: :monetized_journey }

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'protected journey' do
      let(:journey) { create :journey, access_type: :protected_journey }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end

    context 'private journey' do
      let(:journey) { create :journey, access_type: :private_journey }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end
end
