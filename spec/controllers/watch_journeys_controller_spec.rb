# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WatchJourneysController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:journey) { create(:journey, user:, access_type:) }

  context '#show' do
    before do
      sign_in user
    end

    subject do
      get :show, params: {
        access_code:
      }
    end

    context 'access_type' do
      let(:access_code) { journey.access_code }

      context 'access_type is private_journey' do
        let(:access_type) { :private_journey }

        it_behaves_like 'can not view page'
      end

      context 'access_type is protected_journey' do
        let(:access_type) { :protected_journey }

        it_behaves_like 'can view page'
      end
    end

    context 'access_code' do
      let(:access_type) { :protected_journey }

      context 'invalid access_code' do
        let(:access_code) { SecureRandom.uuid }

        it_behaves_like 'can not view page'
      end

      context 'valid access_code' do
        let(:access_code) { journey.access_code }

        it_behaves_like 'can view page'
      end
    end
  end
end
