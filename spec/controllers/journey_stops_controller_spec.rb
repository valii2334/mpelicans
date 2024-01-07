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

      let(:notifier) { double('Notifiers::NewJourneyStop') }

      before do
        allow(Notifiers::NewJourneyStop).to receive(:new).and_return(notifier)
        allow(notifier).to receive(:notify).and_return(nil)
      end

      it 'notifies users' do
        subject

        expect(Notifiers::NewJourneyStop)
          .to have_received(:new).with(
            {
              journey_id: journey.id,
              journey_stop_id: JourneyStop.last.id,
              sender_id: user.id
            }
          )
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

    it 'raises an error if not signed in' do
      expect do
        delete :destroy, params: { journey_id: journey.id, id: second_journey_stop.id }
      end.to raise_error(CanCan::AccessDenied)
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

  RSpec.shared_examples 'journey stop increases views count' do
    it 'increases views count' do
      expect do
        subject
      end.to change { JourneyStop.find(id).views_count }.by(1)
    end
  end

  RSpec.shared_examples 'journey stop does not increase views count' do
    it 'does not increase views count' do
      expect do
        expect do
          subject
        end.to raise_error(CanCan::AccessDenied)
      end.to change { JourneyStop.find(id).views_count }.by(0)
    end
  end

  RSpec.shared_examples 'journey stop does not increase views count and does not raises an error' do
    it 'does not increase views count' do
      expect do
        subject
      end.to change { JourneyStop.find(id).views_count }.by(0)
    end
  end
end
