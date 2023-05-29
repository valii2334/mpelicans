# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlusCodeRetriever do
  let(:latitude)      { '45.753182' }
  let(:longitude)     { '-36.995233' }
  let(:map_api_key)   { 'RandomApiKey' }
  let(:geocoding_url) { PlusCodeRetriever::GOOGLE_REVERSE_GEOCODING_API_URL }
  let(:request_url)   { "#{geocoding_url}#{latitude},#{longitude}&key=#{ENV.fetch('GOOGLE_MAPS_API_KEY', nil)}" }

  subject { described_class.new(latitude:, longitude:).run }

  context 'invalid parameters' do
    context 'latitude is blank' do
      let(:latitude) { '' }

      it 'raises an ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'longitude is blank' do
      let(:longitude) { '   ' }

      it 'raises an ArgumentError' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  context 'valid parameters' do
    context 'request status is not 200' do
      before do
        stub_request(:get, request_url)
          .to_return(status: [500, 'Internal Server Error'])
      end

      it 'raises an error' do
        expect do
          subject
        end.to raise_error(
          StandardError,
          'Google reverse geocoding API responded with: 500. ' \
          "Latitude: #{latitude}, longitude: #{longitude}"
        )
      end
    end

    context 'request status is 200' do
      context 'maps api status is not OK' do
        before do
          stub_request(:get, request_url)
            .to_return(body: Rails.root.join('spec/fixtures/files/google_api_response_failed.json').open, status: 200)
        end

        it 'raises an error' do
          expect do
            subject
          end.to raise_error(StandardError, 'Google reverse geocoding API responded with: REQUEST_DENIED')
        end
      end

      context 'maps api status is OK' do
        before do
          stub_request(:get, request_url)
            .to_return(body: Rails.root.join('spec/fixtures/files/google_api_response_remote.json').open, status: 200)
        end

        it 'raises an error' do
          expect(subject).to eq('89Q5Q233+7V5')
        end
      end
    end
  end
end
