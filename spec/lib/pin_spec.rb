# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pin do
  subject do
    described_class.new(pinnable:).to_pin
  end

  let(:expected_pin) do
    {
      title: pinnable.title,
      link_to_self: pinnable.link_to_self,
      link_to_google_maps: "https://www.google.com/maps/search/?api=1&query=#{pinnable.lat},#{pinnable.long}",
      position: {
        lat: pinnable.lat,
        lng: pinnable.long
      }
    }
  end

  context 'journey_stop' do
    let(:pinnable) { create :journey_stop }

    it 'returns a pin' do
      expect(subject).to eq(expected_pin)
    end
  end
end
