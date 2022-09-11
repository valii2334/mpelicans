# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneysController, type: :controller do
  let(:user) { create(:user) }
  let(:journey) { create(:journey, user: user) }
  let(:second_journey) { create(:journey, user: create(:user)) }

  before do
    user.confirm
  end

  context '#show' do
    it 'redirected if not signed in' do
      get :show, params: { id: journey.id }
      expect(response.status).to eq(302)
    end

    it 'raises an error if others user journey' do
      sign_in user

      expect do
        get :show, params: { id: second_journey.id }
      end.to raise_error(CanCan::AccessDenied)
    end

    it 'can view own journey' do
      sign_in user

      get :show, params: { id: journey.id }
      expect(response.status).to eq(200)
    end
  end

  context '#create' do
    before do
      sign_in user
    end

    subject do
      post :create, params: {
        journey: journey_params
      }
    end

    context 'invalid parameters' do
      context 'missing title' do
        let(:journey_params) do
          {
            description: FFaker::Lorem.paragraph,
            start_plus_code: FFaker::Random.rand,
            image: fixture_file_upload('lasvegas.jpg', 'image/jpeg')
          }
        end

        it 'renders new' do
          expect(subject).to render_template(:new)
        end

        it 'does not create a journey' do
          expect do
            subject
          end.to change { Journey.count }.by(0)
        end
      end

      context 'missing description' do
        let(:journey_params) do
          {
            title: FFaker::Name.name,
            start_plus_code: FFaker::Random.rand,
            image: fixture_file_upload('lasvegas.jpg', 'image/jpeg')
          }
        end

        it 'renders new' do
          expect(subject).to render_template(:new)
        end

        it 'does not create a journey' do
          expect do
            subject
          end.to change { Journey.count }.by(0)
        end
      end

      context 'missing start_plus_code' do
        let(:journey_params) do
          {
            title: FFaker::Name.name,
            description: FFaker::Lorem.paragraph,
            image: fixture_file_upload('lasvegas.jpg', 'image/jpeg')
          }
        end

        it 'renders new' do
          expect(subject).to render_template(:new)
        end

        it 'does not create a journey' do
          expect do
            subject
          end.to change { Journey.count }.by(0)
        end
      end

      context 'missing image' do
        let(:journey_params) do
          {
            title: FFaker::Name.name,
            description: FFaker::Lorem.paragraph,
            start_plus_code: FFaker::Random.rand
          }
        end

        it 'renders new' do
          expect(subject).to render_template(:new)
        end

        it 'does not create a journey' do
          expect do
            subject
          end.to change { Journey.count }.by(0)
        end
      end
    end

    context 'valid parameters' do
      let(:journey_params) do
        {
          title: FFaker::Name.name,
          description: FFaker::Lorem.paragraph,
          start_plus_code: FFaker::Random.rand,
          image: fixture_file_upload('lasvegas.jpg', 'image/jpeg')
        }
      end

      it 'creates journey' do
        expect do
          subject
        end.to change { Journey.count }.by(1)
      end
    end
  end
end
