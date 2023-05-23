# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifier do
  let(:journey) { create :journey, access_type: }
  let(:sender)  { create :user }

  context 'public_journey' do
    let(:access_type) { :public_journey }

    it_behaves_like 'notifications are sent'
  end

  context 'monetized_journey' do
    let(:access_type) { :monetized_journey }

    it_behaves_like 'notifications are sent'
  end

  context 'other access type' do
    let(:access_type) { :private_journey }

    context '#bought_journey' do
      include_context 'bought_journey set up'

      it 'does not create any notifications' do
        expect { subject }.to change { Notification.count }.by(0)
      end
    end

    context '#new_journey' do
      include_context 'new_journey set up'

      it 'does not create any notifications' do
        expect { subject }.to change { Notification.count }.by(0)
      end
    end

    context '#new_journey_stop' do
      include_context 'new_journey_stop set up'

      it 'does not create any notifications' do
        expect { subject }.to change { Notification.count }.by(0)
      end
    end
  end
end
