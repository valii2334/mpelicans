# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MapPinsController, type: :controller do
  render_views

  let(:user) { create :user }

  context '#index' do
    subject do
      get :index
    end

    context 'logged in' do
      before do
        sign_in user
      end

      it 'is successful' do
        subject

        expect(response.status).to eq(200)
      end
    end

    context 'not logged in' do
      it 'it is redirected' do
        subject

        expect(response.status).to eq(302)
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

      it 'creates a MapPin with attributes', :aggregate_failures do
        expect do
          subject
        end.to change { user.map_pins.count }.by(1)

        map_pin = user.map_pins.last

        expect(map_pin.user).to eq(user)
        expect(map_pin.journey_stop).to eq(journey_stop)
        expect(map_pin.lat).to eq(journey_stop.lat)
        expect(map_pin.long).to eq(journey_stop.long)
        expect(map_pin.title).to eq(journey_stop.title)
        expect(map_pin.place_id).to eq(journey_stop.place_id)
      end
    end

    context 'not logged in' do
      it 'it is redirected' do
        subject

        expect(response.status).to eq(302)
      end
    end
  end

  context 'destroy' do
    let!(:map_pin) { create :map_pin, user: }

    subject do
      delete :destroy, params: { id: map_pin.id }
    end

    context 'logged in' do
      before do
        sign_in user
      end

      context 'can destroy map pin of current user' do
        it 'it is successful' do
          subject

          expect(response.status).to eq(200)
        end

        it 'destroys a MapPin' do
          expect do
            subject
          end.to change { user.map_pins.count }.by(-1)
        end
      end

      context 'can not destroy pin of another user' do
        let!(:map_pin) { create :map_pin }

        it 'returns an error' do
          expect { subject }.to raise_error(CanCan::AccessDenied)
        end
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
