# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneyAcquisitionsController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:journey) { create(:journey, user:) }
  let(:second_user) { create(:user) }
  let(:second_journey) { create(:journey, user: second_user) }
  let(:params) do
    {
      journey_id: second_journey.id
    }
  end

  before do
    user.confirm
  end

  context '#create' do
    subject do
      post :create, params: params
    end

    context 'not signed in' do
      it 'will be redirect to sign in page' do
        subject

        expect(response.status).to redirect_to(new_user_session_path)
      end

      it 'will not create a PaidJourney' do
        expect do
          subject
        end.to change { PaidJourney.count }.by(0)
      end
    end

    context 'signed in' do
      before do
        sign_in user
      end

      context 'valid parameters' do
        context 'journey is monetized' do
          context 'other users journey' do
            before do
              second_journey.update(access_type: :monetized_journey)
            end

            it 'creates a PaidJourney' do
              expect do
                subject
              end.to change { PaidJourney.count }.by(1)
            end

            it 'redirects to journey path' do
              subject

              expect(response.status).to redirect_to(journey_path(second_journey))
            end
          end
        end

        context 'journey is not monetized' do
          before do
            second_journey.update(access_type: :private_journey)
          end

          it 'raises an error' do
            expect do
              subject
            end.to raise_error(CanCan::AccessDenied)
          end
        end
      end

      context 'invalid parameters' do
        context 'missing journey_id' do
          let(:params) do
            {
              user_id: user.id,
              journey_id: nil
            }
          end

          it 'raises an error' do
            expect do
              subject
            end.to raise_error(
              ActionController::ParameterMissing,
              'param is missing or the value is empty: journey_id'
            )
          end
        end
      end
    end
  end
end
