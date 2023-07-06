# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Retrievers::Journey do
  let!(:random_processed_monetized_journey) do
    create :journey, image_processing_status: :processed, access_type: :monetized_journey
  end
  let!(:random_processed_public_journey) do
    create :journey, image_processing_status: :processed, access_type: :public_journey
  end
  let!(:random_processed_protected_journey) do
    create :journey, image_processing_status: :processed, access_type: :protected_journey
  end
  let!(:random_processed_private_journey) do
    create :journey, image_processing_status: :processed, access_type: :private_journey
  end

  let!(:random_not_processed_monetized_journey) do
    create :journey, image_processing_status: :processing, access_type: :monetized_journey
  end
  let!(:random_not_processed_public_journey) do
    create :journey, image_processing_status: :processing, access_type: :public_journey
  end
  let!(:random_not_processed_protected_journey) do
    create :journey, image_processing_status: :processing, access_type: :protected_journey
  end
  let!(:random_not_processed_private_journey) do
    create :journey, image_processing_status: :processing, access_type: :private_journey
  end

  let(:user)           { nil }
  let(:which_journeys) { nil }

  describe '#fetch' do
    subject do
      described_class.new(user:, which_journeys:).fetch
    end

    context 'user is nil' do
      it 'returns processed monetized and public journeys only' do
        expect(subject).to match_array([random_processed_monetized_journey, random_processed_public_journey])
      end
    end

    context 'user is not nil' do
      let(:user) { create :user }

      let!(:cu_processed_monetized_journey) do
        create :journey, user:, image_processing_status: :processed, access_type: :monetized_journey
      end
      let!(:cu_processed_public_journey) do
        create :journey, user:, image_processing_status: :processed, access_type: :public_journey
      end
      let!(:cu_processed_protected_journey) do
        create :journey, user:, image_processing_status: :processed, access_type: :protected_journey
      end
      let!(:cu_processed_private_journey) do
        create :journey, user:, image_processing_status: :processed, access_type: :private_journey
      end

      let!(:cu_not_processed_monetized_journey) do
        create :journey, user:, image_processing_status: :processing, access_type: :monetized_journey
      end
      let!(:cu_not_processed_public_journey) do
        create :journey, user:, image_processing_status: :processing, access_type: :public_journey
      end
      let!(:cu_not_processed_protected_journey) do
        create :journey, user:, image_processing_status: :processing, access_type: :protected_journey
      end
      let!(:cu_not_processed_private_journey) do
        create :journey, user:, image_processing_status: :processing, access_type: :private_journey
      end

      context 'which_journeys is users' do
        let(:which_journeys) { 'users' }

        it 'returns users processed monetized and public journeys only' do
          expect(subject).to match_array(
            [cu_processed_monetized_journey, cu_processed_public_journey]
          )
        end
      end

      context 'which_journeys is mine' do
        let(:which_journeys) { 'mine' }

        it 'returns users journeys regardless of access_type' do
          expect(subject).to match_array(
            [
              cu_processed_monetized_journey,
              cu_processed_public_journey,
              cu_processed_protected_journey,
              cu_processed_private_journey,
              cu_not_processed_monetized_journey,
              cu_not_processed_public_journey,
              cu_not_processed_protected_journey,
              cu_not_processed_private_journey
            ]
          )
        end
      end

      context 'which_journeys is bought' do
        let(:which_journeys) { 'bought' }

        let!(:random_bought_monetized_journey) { create :journey, access_type: :monetized_journey }
        let!(:random_bought_public_journey)    { create :journey, access_type: :public_journey }
        let!(:random_bought_protected_journey) { create :journey, access_type: :protected_journey }
        let!(:random_bought_private_journey)   { create :journey, access_type: :private_journey }

        let!(:paid_journey0) { create :paid_journey, user:, journey: random_bought_monetized_journey }
        let!(:paid_journey1) { create :paid_journey, user:, journey: random_bought_public_journey }
        let!(:paid_journey2) { create :paid_journey, user:, journey: random_bought_protected_journey }
        let!(:paid_journey3) { create :paid_journey, user:, journey: random_bought_private_journey }

        it 'returns users bought_journeys which are public or monetized' do
          expect(subject).to match_array(
            [
              random_bought_monetized_journey, random_bought_public_journey
            ]
          )
        end
      end

      context 'which_journeys is a random string' do
        let(:which_journeys) { 'random string' }

        it 'returns an empty array' do
          expect(subject).to match_array([])
        end
      end
    end
  end
end
