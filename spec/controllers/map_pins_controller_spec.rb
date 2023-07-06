# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MapPinsController, type: :controller do
  render_views

  let(:user) { create :user }

  context '#index' do
    context 'logged in' do
      before do
        sign_in user
      end

      it 'is successful' do
        get :index

        expect(response.status).to eq(200)
      end
    end

    context 'not logged in' do
      it 'is successful' do
        get :index

        expect(response.status).to eq(200)
      end
    end
  end

  context '#create' do
    let(:journey_stop) { create :journey_stop }

    subject do
      post :create, params: { journey_stop_id: journey_stop.id }
    end

    context 'logged in' do
      before do
        sign_in user
      end

      it 'it is successful' do
        subject

        expect(response.status).to eq(200)
      end

      it 'creates a MapPin' do
        expect do
          subject
        end.to change { user.map_pins.count }.by(1)
      end
    end

    context 'not logged in' do
      it 'it is redirected' do
        subject

        expect(response.status).to eq(302)
      end
    end
  end
end
