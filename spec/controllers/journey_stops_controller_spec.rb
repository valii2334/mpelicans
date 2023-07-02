# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneyStopsController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:journey) { create(:journey, user:) }
  let(:second_journey) { create(:journey, user: create(:user)) }

  context '#create' do
    before do
      sign_in user
    end

    subject do
      post :create, params: {
        journey_id: journey.id,
        journey_stop: journey_stop_params
      }
    end

    context 'authorization' do
      let(:journey_stop_params) do
        {
          title: FFaker::Name.name,
          description: FFaker::Lorem.paragraph,
          lat: '46.749971',
          long: '23.598739',
          images: [fixture_file_upload('lasvegas.jpg', 'image/jpeg')],
          journey_id: second_journey.id
        }
      end

      it 'can not create a journey stop for others user journey' do
        expect do
          subject
        end.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'invalid parameters' do
      context 'missing title' do
        let(:journey_stop_params) do
          {
            description: FFaker::Lorem.paragraph,
            lat: '46.749971',
            long: '23.598739',
            images: [fixture_file_upload('lasvegas.jpg', 'image/jpeg')],
            journey_id: journey.id
          }
        end

        include_examples 'missing parameter', JourneyStop, 'Title'
      end

      context 'missing lat' do
        let(:journey_stop_params) do
          {
            title: FFaker::Name.name,
            description: FFaker::Lorem.paragraph,
            images: [fixture_file_upload('lasvegas.jpg', 'image/jpeg')],
            long: '23.598739',
            journey_id: journey.id
          }
        end

        include_examples 'missing parameter', JourneyStop, 'Lat'
      end

      context 'missing long' do
        let(:journey_stop_params) do
          {
            title: FFaker::Name.name,
            description: FFaker::Lorem.paragraph,
            images: [fixture_file_upload('lasvegas.jpg', 'image/jpeg')],
            lat: '46.749971',
            journey_id: journey.id
          }
        end

        include_examples 'missing parameter', JourneyStop, 'Long'
      end

      context 'missing images' do
        let(:journey_stop_params) do
          {
            title: FFaker::Name.name,
            description: FFaker::Lorem.paragraph,
            plus_code: FFaker::Random.rand,
            journey_id: journey.id
          }
        end

        include_examples 'missing parameter', JourneyStop, 'Images'
      end

      context 'more images than MAXIMUM_NUMBER_OF_IMAGES' do
        let(:journey_stop_params) do
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
            ],
            journey_id: journey.id
          }
        end

        it 'does not create a JourneyStop' do
          expect do
            subject
          end.to change { JourneyStop.count }.by(0)
        end

        it 'includes error message' do
          expect(CGI.unescapeHTML(subject.body)).to include(
            "can't post more than #{JourneyStop::MAXIMUM_NUMBER_OF_IMAGES}"
          )
        end
      end
    end

    context 'valid parameters' do
      let(:journey_stop_params) do
        {
          title: FFaker::Name.name,
          description: FFaker::Lorem.paragraph,
          lat: '46.749971',
          long: '23.598739',
          images: [fixture_file_upload('lasvegas.jpg', 'image/jpeg')],
          journey_id: journey.id
        }
      end

      it 'creates journey stop' do
        expect do
          subject
        end.to change { JourneyStop.count }.by(1)
      end

      let(:notifier) { double('Notifier') }

      before do
        allow(notifier).to receive(:notify).and_return(nil)
      end

      it 'notifies users' do
        expect(Notifier).to receive(:new).with(
          {
            journey_id: journey.id,
            notification_type: :new_journey_stop,
            sender_id: user.id
          }
        ).and_return(notifier)

        subject
      end
    end
  end

  context '#new' do
    before do
      sign_in user
    end

    subject do
      get :new, params: {
        journey_id: journey.id
      }
    end

    it 'renders new' do
      subject

      expect(response.status).to eq(200)
    end
  end

  context '#destroy' do
    let(:journey_stop) { create(:journey_stop, journey:) }
    let(:second_journey_stop) { create(:journey_stop, journey: second_journey) }

    it 'redirected if not signed in' do
      delete :destroy, params: { journey_id: journey.id, id: journey_stop.id }
      expect(response.status).to eq(302)
    end

    it 'raises an error if other users journey' do
      sign_in user

      expect do
        delete :destroy, params: { journey_id: second_journey.id, id: second_journey_stop.id }
      end.to raise_error(CanCan::AccessDenied)
    end

    it 'raises an error if own journey but other users journey stop' do
      sign_in user

      expect do
        delete :destroy, params: { journey_id: journey.id, id: second_journey_stop.id }
      end.to raise_error(CanCan::AccessDenied)
    end

    it 'can destroy own journey stop' do
      sign_in user

      delete :destroy, params: { journey_id: journey.id, id: journey_stop.id }

      expect(response.status).to redirect_to(journey_path(journey))
      expect(JourneyStop.find_by(id: journey_stop.id)).to be_nil
    end
  end

  context '#show' do
    let(:access_code) { second_journey.access_code }
    let(:journey_stop) { create(:journey_stop, journey:) }
    let(:second_journey) { create(:journey, access_type:, user: create(:user)) }
    let(:second_journey_stop) { create(:journey_stop, journey: second_journey) }

    subject do
      get :show, params: {
        access_code:,
        journey_id:,
        id:
      }
    end

    context 'signed in' do
      before do
        sign_in user
      end

      context 'own journey stop' do
        let(:access_type) { :private_journey }
        let(:journey_id) { journey.id }
        let(:id) { journey_stop.id }

        it_behaves_like 'can view page'
      end

      context 'other users journeys' do
        let(:journey_id) { second_journey.id }
        let(:id) { second_journey_stop.id }

        context 'private journey' do
          let(:access_type) { :private_journey }

          it_behaves_like 'can not view page'
        end

        context 'public journey' do
          let(:access_type) { :public_journey }

          it_behaves_like 'can view page'
        end

        context 'protected journey' do
          let(:access_type) { :protected_journey }

          context 'without access_code' do
            subject do
              get :show, params: {
                journey_id:,
                id:
              }
            end

            it_behaves_like 'can not view page'
          end

          context 'with access_code' do
            it_behaves_like 'can view page'
          end
        end

        context 'monetized journey' do
          let(:access_type) { :monetized_journey }

          context 'not bought journey' do
            it_behaves_like 'can not view page'
          end

          context 'bought journey' do
            before do
              create(:paid_journey, user:, journey: second_journey)
            end

            it_behaves_like 'can view page'
          end
        end
      end
    end

    context 'not signed in' do
      let(:journey_id) { second_journey.id }
      let(:id) { second_journey_stop.id }

      context 'private journey' do
        let(:access_type) { :private_journey }

        it_behaves_like 'can not view page'
      end

      context 'public journey' do
        let(:access_type) { :public_journey }

        it_behaves_like 'can view page'
      end

      context 'protected journey' do
        let(:access_type) { :protected_journey }

        context 'access_code in params' do
          it_behaves_like 'can view page'
        end

        context 'access_code is not in params' do
          subject do
            get :show, params: {
              journey_id:,
              id:
            }
          end

          it_behaves_like 'can not view page'
        end
      end

      context 'monetized journey' do
        let(:access_type) { :monetized_journey }

        it_behaves_like 'can not view page'
      end
    end
  end
end
