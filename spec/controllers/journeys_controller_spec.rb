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
    subject do
      get :show, params: { id: journey_id }
    end

    context 'other users journey' do
      let(:journey_id) { second_journey.id }

      before do
        sign_in user
      end

      context 'private_journey' do
        it_behaves_like 'can not view page'
      end

      context 'protected_journey' do
        before do
          second_journey.update(access_type: :protected_journey)
        end

        it_behaves_like 'can not view page'
      end

      context 'public_journey' do
        before do
          second_journey.update(access_type: :public_journey)
        end

        it_behaves_like 'can view page'
      end

      context 'monetized_journey' do
        before do
          second_journey.update(access_type: :monetized_journey)
        end

        context 'not paid' do
          it_behaves_like 'can not view page'
        end

        context 'purchased this journey' do
          before do
            create(:paid_journey, user:, journey: second_journey)
          end

          it_behaves_like 'can view page'
        end
      end
    end

    context 'own journey' do
      let(:journey_id) { journey.id }

      before do
        sign_in user
      end

      it_behaves_like 'can view page'
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

          it_behaves_like 'can not view page'
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

    it_behaves_like 'can view page'
  end

  context '#index' do
    before do
      sign_in user
    end

    subject do
      get :index
    end

    it_behaves_like 'can view page'
  end

  context '#destroy' do
    subject do
      delete :destroy, params: { id: journey_id }
    end

    context 'not signed in' do
      let(:journey_id) { journey.id }

      it 'redirected if not signed in' do
        subject

        expect(response.status).to eq(302)
      end
    end

    context 'signed in' do
      before do
        sign_in user
      end

      context 'raises an error if others user journey' do
        let(:journey_id) { second_journey.id }

        it_behaves_like 'can not view page'
      end

      context 'can destroy own journey' do
        let(:journey_id) { journey.id }

        it 'redirects to journey' do
          subject

          expect(response.status).to redirect_to(root_path)
        end

        it 'destroys journey' do
          subject

          expect(Journey.find_by(id: journey.id)).to be_nil
        end
      end
    end
  end

  context '#update' do
    let(:access_type) { :protected_journey }

    subject do
      put :update, params: { id: journey_id, journey: { access_type: } }
    end

    context 'not signed in' do
      let(:journey_id) { journey.id }

      it 'redirected if not signed in' do
        subject

        expect(response.status).to eq(302)
      end
    end

    context 'signed in' do
      before do
        sign_in user
      end

      context 'own journey' do
        let(:journey_id) { journey.id }

        it 'redirects to journey' do
          subject

          expect(response.status).to redirect_to(journey_path(journey))
        end

        it 'updates journey' do
          subject

          expect(journey.reload.access_type).to eq('protected_journey')
        end
      end

      context 'other users journey' do
        let(:journey_id) { second_journey.id }

        it_behaves_like 'can not view page'
      end
    end
  end
end
