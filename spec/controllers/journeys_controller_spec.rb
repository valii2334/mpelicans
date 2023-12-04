# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneysController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:journey) { create(:journey, user:) }
  let(:second_user) { create(:user) }
  let(:second_journey) { create(:journey, user: second_user) }

  RSpec.shared_examples 'increases views count' do
    it 'increases views count' do
      expect do
        subject
      end.to change { Journey.find(journey_id).views_count }.by(1)
    end
  end

  RSpec.shared_examples 'does not increase views count' do
    it 'does not increase views count' do
      expect do
        expect do
          subject
        end.to raise_error(CanCan::AccessDenied)
      end.to change { Journey.find(journey_id).views_count }.by(0)
    end
  end

  RSpec.shared_examples 'does not increase views count and does not raises an error' do
    it 'does not increase views count' do
      expect do
        subject
      end.to change { Journey.find(journey_id).views_count }.by(0)
    end
  end

  context '#show' do
    subject do
      get :show, params: { id: journey_id, access_code: second_journey.access_code }
    end

    context 'other users journey' do
      let(:journey_id) { second_journey.id }

      before do
        sign_in user
      end

      context 'private_journey' do
        it_behaves_like 'can not view page'
        it_behaves_like 'does not increase views count'
      end

      context 'protected_journey' do
        before do
          second_journey.update(access_type: :protected_journey)
        end

        context 'params contain access_code' do
          it_behaves_like 'can view page'
          it_behaves_like 'increases views count'
        end

        context 'params does not contain access_code' do
          subject do
            get :show, params: { id: journey_id }
          end

          it_behaves_like 'can not view page'
          it_behaves_like 'does not increase views count'
        end
      end

      context 'public_journey' do
        before do
          second_journey.update(access_type: :public_journey)
        end

        it_behaves_like 'can view page'
        it_behaves_like 'increases views count'
      end

      context 'monetized_journey' do
        before do
          second_journey.update(access_type: :monetized_journey)
        end

        context 'not paid' do
          it_behaves_like 'can not view page'
          it_behaves_like 'does not increase views count'
        end

        context 'purchased this journey' do
          before do
            create(:paid_journey, user:, journey: second_journey)
          end

          it_behaves_like 'can view page'
          it_behaves_like 'increases views count'
        end
      end
    end

    context 'own journey' do
      let(:journey_id) { journey.id }

      before do
        sign_in user
      end

      it_behaves_like 'can view page'
      it_behaves_like 'does not increase views count and does not raises an error'
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
      context 'for current user' do
        context 'invalid parameters' do
          context 'missing title' do
            let(:journey_params) do
              {
                description: FFaker::Lorem.paragraph,
                images: [fixture_file_upload('lasvegas.jpg', 'image/jpeg')],
                user_id: user.id
              }
            end

            include_examples 'missing parameter', Journey, 'Title'
          end

          context 'missing image' do
            let(:journey_params) do
              {
                description: FFaker::Lorem.paragraph,
                title: FFaker::Name.name,
                user_id: user.id
              }
            end

            include_examples 'missing parameter', Journey, 'Images'
          end

          context 'more images than MAXIMUM_NUMBER_OF_IMAGES' do
            let(:journey_params) do
              {
                title: FFaker::Name.name,
                description: FFaker::Lorem.paragraph,
                lat: '46.749971',
                long: '23.598739',
                images: [
                  fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
                  fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
                  fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
                  fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
                  fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
                  fixture_file_upload('lasvegas.jpg', 'image/jpeg')
                ]
              }
            end

            it 'does not create a Journey' do
              expect do
                subject
              end.to change { Journey.count }.by(0)
            end

            it 'includes error message' do
              expect(CGI.unescapeHTML(subject.body)).to include(
                "can't post more than #{Journey::MAXIMUM_NUMBER_OF_IMAGES}"
              )
            end
          end
        end

        context 'valid parameters' do
          let(:access_type) { :public_journey }

          let(:journey_params) do
            {
              access_type:,
              description: FFaker::Lorem.paragraph,
              images: [fixture_file_upload('lasvegas.jpg', 'image/jpeg')],
              title: FFaker::Name.name,
              user_id: user.id
            }
          end

          it 'creates journey' do
            expect do
              subject
            end.to change { Journey.count }.by(1)
          end

          let(:notifier) { double('Notifiers::NewJourney') }

          before do
            allow(Notifiers::NewJourney).to receive(:new).and_return(notifier)
            allow(notifier).to receive(:notify).and_return(nil)
          end

          it 'does notify users' do
            subject

            expect(Notifiers::NewJourney)
              .to have_received(:new).with({
                                             journey_id: Journey.last.id,
                                             sender_id: user.id
                                           })
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

    context 'valid which_journeys param' do
      subject do
        get :index, params: { which_journeys: 'latest' }
      end
  
      it_behaves_like 'can view page'
    end

    context 'invalid which_journeys param' do
      subject do
        get :index, params: { which_journeys: 'random_strong' }
      end

      it 'is redirect to view latest journeys' do
        subject

        expect(response).to be_redirect
        expect(response.redirect_url).to include('/journeys?which_journeys=latest')
      end
    end
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
end
