# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneysController, type: :controller do
  let(:journey) { create(:journey) }
  let(:second_journey) { create(:journey, user: create(:user)) }

  before do
    journey.user.confirm
  end

  context '#show' do
    it 'redirected if not signed in' do
      get :show, params: { id: journey.id }
      expect(response.status).to eq(302)
    end

    it 'raises an error if others user journey' do
      sign_in journey.user

      expect do
        get :show, params: { id: second_journey.id }
      end.to raise_error(CanCan::AccessDenied)
    end

    it 'can view own journey' do
      sign_in journey.user

      get :show, params: { id: journey.id }
      expect(response.status).to eq(200)
    end
  end
end
