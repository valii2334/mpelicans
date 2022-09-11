# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneyStopsController, type: :controller do
  let(:user) { create(:user) }
  let(:journey) { create(:journey, user: user) }
  let(:second_journey) { create(:journey, user: create(:user)) }

  before do
    user.confirm
  end

  context '#create' do
    before do
      sign_in user
    end

    subject do
      post :create, params: {
        journey_stop: journey_stop_params
      }
    end

    context 'authorization' do
      let(:journey_stop_params) do
        {
          title: FFaker::Name.name,
          description: FFaker::Lorem.paragraph,
          plus_code: FFaker::Random.rand,
          images: [ fixture_file_upload('lasvegas.jpg', 'image/jpeg') ],
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
            plus_code: FFaker::Random.rand,
            images: [ fixture_file_upload('lasvegas.jpg', 'image/jpeg') ],
            journey_id: journey.id
          }
        end

        it 'renders new' do
          expect(subject).to render_template(:new)
        end

        it 'does not create a journey stop' do
          expect do
            subject
          end.to change { JourneyStop.count }.by(0)
        end
      end

      context 'missing description' do
        let(:journey_stop_params) do
          {
            title: FFaker::Name.name,
            plus_code: FFaker::Random.rand,
            images: [ fixture_file_upload('lasvegas.jpg', 'image/jpeg') ],
            journey_id: journey.id
          }
        end

        it 'renders new' do
          expect(subject).to render_template(:new)
        end

        it 'does not create a journey stop' do
          expect do
            subject
          end.to change { JourneyStop.count }.by(0)
        end
      end

      context 'missing plus_code' do
        let(:journey_stop_params) do
          {
            title: FFaker::Name.name,
            description: FFaker::Lorem.paragraph,
            images: [ fixture_file_upload('lasvegas.jpg', 'image/jpeg') ],
            journey_id: journey.id
          }
        end

        it 'renders new' do
          expect(subject).to render_template(:new)
        end

        it 'does not create a journey stop' do
          expect do
            subject
          end.to change { JourneyStop.count }.by(0)
        end
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

        it 'renders new' do
          expect(subject).to render_template(:new)
        end

        it 'does not create a journey' do
          expect do
            subject
          end.to change { JourneyStop.count }.by(0)
        end
      end
    end

    context 'valid parameters' do
      let(:journey_stop_params) do
        {
          title: FFaker::Name.name,
          description: FFaker::Lorem.paragraph,
          plus_code: FFaker::Random.rand,
          images: [ fixture_file_upload('lasvegas.jpg', 'image/jpeg') ],
          journey_id: journey.id
        }
      end

      it 'creates journey stop' do
        expect do
          subject
        end.to change { JourneyStop.count }.by(1)
      end
    end
  end
end
