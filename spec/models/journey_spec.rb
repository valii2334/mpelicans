# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Journey, type: :model do
  let(:journey) { build(:journey) }
  subject { journey }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :title }
  it { should have_attribute :description }
  it { should have_attribute :start_plus_code }
  it { should have_attribute :status }
  it { should have_attribute :access_type }
  it { should have_attribute :accepts_recommendations }
  it { should have_attribute :user_id }
  it { should have_attribute :access_code }

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :start_plus_code }

  ##################################
  # Associations
  ##################################

  it { should belong_to(:user) }
  it { should have_many(:journey_stops).dependent(:destroy) }
  it { should have_many(:paid_journeys).dependent(:destroy) }

  ##################################
  # Callbacks
  ##################################

  context '#add_access_code' do
    it 'adds an access code' do
      journey = create(:journey)

      expect(journey.access_code).to_not be_nil
    end
  end

  ##################################
  # Methods
  ##################################

  context '#map_url' do
    context 'journey has no stops' do
      it 'returns map url without destination or waypoints' do
        start_plus_code = 'STARTPLUSCODE'
        journey = create(:journey, start_plus_code:)

        expected_map_url = 'https://www.google.com/maps/embed/v1/place' \
                           "?key=#{ENV.fetch('GOOGLE_MAPS_API_KEY', nil)}&q=#{start_plus_code}"
        expect(journey.map_url).to eq(expected_map_url)
      end
    end

    context 'journey has one stop' do
      it 'returns map url with origin and destination' do
        start_plus_code = 'STARTPLUSCODE'
        journey = create(:journey, start_plus_code:)
        plus_code = 'PLUSCODE'
        create(:journey_stop, journey:, plus_code:)

        expected_map_url = 'https://www.google.com/maps/embed/v1/directions' \
                           "?key=#{ENV.fetch('GOOGLE_MAPS_API_KEY',
                                             nil)}&origin=#{start_plus_code}&destination=#{plus_code}"
        expect(journey.map_url).to eq(expected_map_url)
      end
    end

    context 'journey has at least two stops' do
      it 'returns map url with origin, destination and waypoints' do
        start_plus_code = 'STARTPLUSCODE'
        journey = create(:journey, start_plus_code:)
        plus_code = 'PLUSCODE'
        create(:journey_stop, journey:, plus_code:)
        second_plus_code = 'PLUSCODESECOND'
        create(:journey_stop, journey:, plus_code: second_plus_code)
        third_plus_code = 'PLUSCODETHIRD'
        create(:journey_stop, journey:, plus_code: third_plus_code)

        expected_map_url = 'https://www.google.com/maps/embed/v1/directions' \
                           "?key=#{ENV.fetch('GOOGLE_MAPS_API_KEY', nil)}" \
                           "&origin=#{start_plus_code}" \
                           "&destination=#{third_plus_code}" \
                           "&waypoints=#{plus_code}|#{second_plus_code}"
        expect(journey.map_url).to eq(expected_map_url)
      end
    end
  end
end
