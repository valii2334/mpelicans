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
      link_to_google_maps: pinnable.link_to_google_maps,
      position: {
        lat: pinnable.lat,
        lng: pinnable.long
      }
    }
  end
end
