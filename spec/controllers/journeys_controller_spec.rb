# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneysController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:journey) { create(:journey, user:) }
  let(:second_user) { create(:user) }
  let(:second_journey) { create(:journey, user: second_user) }

  before do
    user.confirm
  end

  context '#show' do
    context 'other users journey' do
      context 'private_journey' do
        it 'raises an error if private journey' do
          sign_in user

          expect do
            get :show, params: { id: second_journey.id }
          end.to raise_error(CanCan::AccessDenied)
        end
      end

      context 'protected_journey' do
        before do
          second_journey.update(access_type: :protected_journey)
        end

        it 'raises an error if protected journey' do
          expect do
            get :show, params: { id: second_journey.id }
          end.to raise_error(CanCan::AccessDenied)
        end
      end

      context 'public_journey' do
        before do
          second_journey.update(access_type: :public_journey)
        end

        it 'can view journey' do
          get :show, params: { id: second_journey.id }
          expect(response.status).to eq(200)
        end
      end

      context 'monetized_journey' do
        before do
          second_journey.update(access_type: :monetized_journey)
        end

        context 'not paid' do
          it 'raises an error if protected journey' do
            expect do
              get :show, params: { id: second_journey.id }
            end.to raise_error(CanCan::AccessDenied)
          end
        end

        context 'purchased this journey' do
          before do
            create(:paid_journey, user:, journey: second_journey)
          end

          it 'can view journey' do
            sign_in user

            get :show, params: { id: second_journey.id }
            expect(response.status).to eq(200)
          end
        end
      end
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

    context 'authorization' do
      context 'for other user' do
        context 'valid parameters' do
          let(:journey_params) do
            {
              description: FFaker::Lorem.paragraph,
              image: fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
              start_plus_code: FFaker::Random.rand,
              title: FFaker::Name.name,
              user_id: second_user.id
            }
          end

          it 'creates journey' do
            expect do
              subject
            end.to raise_error(CanCan::AccessDenied)
          end
        end
      end

      context 'for current user' do
        context 'invalid parameters' do
          context 'missing title' do
            let(:journey_params) do
              {
                description: FFaker::Lorem.paragraph,
                image: fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
                start_plus_code: FFaker::Random.rand,
                user_id: user.id
              }
            end

            include_examples 'missing parameter', Journey, 'Title'
          end

          context 'missing description' do
            let(:journey_params) do
              {
                image: fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
                start_plus_code: FFaker::Random.rand,
                title: FFaker::Name.name,
                user_id: user.id
              }
            end

            include_examples 'missing parameter', Journey, 'Description'
          end

          context 'missing start_plus_code' do
            let(:journey_params) do
              {
                description: FFaker::Lorem.paragraph,
                image: fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
                title: FFaker::Name.name,
                user_id: user.id
              }
            end

            include_examples 'missing parameter', Journey, 'Start plus code'
          end

          context 'missing image' do
            let(:journey_params) do
              {
                description: FFaker::Lorem.paragraph,
                start_plus_code: FFaker::Random.rand,
                title: FFaker::Name.name,
                user_id: user.id
              }
            end

            include_examples 'missing parameter', Journey, 'Image'
          end
        end

        context 'valid parameters' do
          let(:journey_params) do
            {
              description: FFaker::Lorem.paragraph,
              image: fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
              start_plus_code: FFaker::Random.rand,
              title: FFaker::Name.name,
              user_id: user.id
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
  end

  context '#new' do
    before do
      sign_in user
    end

    subject do
      get :new
    end

    it 'renders new' do
      subject

      expect(response.status).to eq(200)
    end
  end

  context '#index' do
    before do
      sign_in user
    end

    subject do
      get :index
    end

    it 'renders new' do
      subject

      expect(response.status).to eq(200)
    end
  end

  context '#destroy' do
    it 'redirected if not signed in' do
      delete :destroy, params: { id: journey.id }
      expect(response.status).to eq(302)
    end

    it 'raises an error if others user journey' do
      sign_in user

      expect do
        delete :destroy, params: { id: second_journey.id }
      end.to raise_error(CanCan::AccessDenied)
    end

    it 'can destroy own journey' do
      sign_in user

      delete :destroy, params: { id: journey.id }

      expect(response.status).to redirect_to(root_path)
      expect(Journey.find_by(id: journey.id)).to be_nil
    end
  end

  context '#update' do
    it 'redirected if not signed in' do
      put :update, params: { id: journey.id, access_type: :protected_journey }
      expect(response.status).to eq(302)
    end

    it 'raises an error if others user journey' do
      sign_in user

      expect do
        put :update, params: { id: second_journey.id, access_type: :protected_journey }
      end.to raise_error(CanCan::AccessDenied)
    end

    it 'can update own journey' do
      sign_in user

      put :update, params: { id: journey.id, journey: { access_type: :protected_journey } }

      expect(response.status).to redirect_to(journey_path(journey))
      expect(journey.reload.access_type).to eq('protected_journey')
    end
  end
end
