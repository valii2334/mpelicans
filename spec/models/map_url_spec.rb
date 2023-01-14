# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MapUrl, type: :model do
  context '#map_url' do
    let(:origin) { 'STARTPLUSCODE' }
    let(:destination) { 'PLUSCODE' }
    let(:waypoints) { %w[PLUSCODESECOND PLUSCODETHIRD] }

    context 'only origin' do
      it 'returns map url without destination or waypoints' do
        expected_map_url = 'https://www.google.com/maps/embed/v1/place' \
                           "?key=#{ENV.fetch('GOOGLE_MAPS_API_KEY', nil)}&q=#{origin}"

        expect(described_class.new(origin:).map_url).to eq(expected_map_url)
      end
    end

    context 'origin and destination' do
      it 'returns map url with origin and destination' do
        expected_map_url = 'https://www.google.com/maps/embed/v1/directions' \
                           "?key=#{ENV.fetch('GOOGLE_MAPS_API_KEY',
                                             nil)}&origin=#{origin}&destination=#{destination}"

        expect(described_class.new(origin:, destination:).map_url).to eq(expected_map_url)
      end
    end

    context 'origin, destination and waypoints' do
      it 'returns map url with origin, destination and waypoints' do
        expected_map_url = 'https://www.google.com/maps/embed/v1/directions' \
                           "?key=#{ENV.fetch('GOOGLE_MAPS_API_KEY', nil)}" \
                           "&origin=#{origin}" \
                           "&destination=#{destination}" \
                           "&waypoints=#{waypoints[0]}|#{waypoints[1]}"

        expect(described_class.new(origin:, destination:, waypoints:).map_url).to eq(expected_map_url)
      end
    end
  end
end
