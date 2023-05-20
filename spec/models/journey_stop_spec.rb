# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneyStop, type: :model do
  let(:journey_stop) { build(:journey_stop) }
  subject { journey_stop }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :title }
  it { should have_attribute :description }
  it { should have_attribute :passed_images }
  it { should have_attribute :plus_code }
  it { should have_attribute :journey_id }

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :plus_code }

  ##################################
  # Associations
  ##################################

  it { should belong_to(:journey) }

  ##################################
  # Methods
  ##################################

  describe '#location_link' do
    let(:journey_stop) { build(:journey_stop) }

    it 'returns location_link' do
      expect(journey_stop.location_link).to eq("https://www.plus.codes/#{journey_stop.plus_code}")
    end
  end
end
