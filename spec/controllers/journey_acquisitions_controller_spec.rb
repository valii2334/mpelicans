# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneyAcquisitionsController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:second_journey) { create(:journey, user: second_user) }
  let(:params) do
    {
      journey_id: second_journey.id
    }
  end
  let(:payment_status) { 'paid' }

  let(:metadata) do
    double('Metadata', journey_id: second_journey.id, user_id: user.id)
  end

  let(:stripe_checkout_session) do
    double('Stripe::CheckoutSession', metadata:, payment_status:)
  end

  before do
    allow(Stripe::Checkout::Session).to receive(:retrieve).and_return(stripe_checkout_session)
  end

  context '#checkout_session_redirect' do
    subject do
      get :checkout_session_redirect, params:
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
            let(:notifier) { double('Notifiers::BoughtJourney') }

            before do
              second_journey.update(access_type: :monetized_journey)
              allow(notifier).to receive(:notify).and_return(nil)
            end

            context 'payment_status is paid' do
              let(:payment_status) { 'paid' }

              it 'creates a PaidJourney' do
                expect do
                  subject
                end.to change { PaidJourney.count }.by(1)
              end

              it 'notifies users' do
                expect(Notifiers::BoughtJourney).to receive(:new).with(
                  {
                    journey_id: second_journey.id,
                    sender_id: user.id
                  }
                ).and_return(notifier)

                subject
              end

              it 'redirects to journey path' do
                subject

                expect(response.status).to redirect_to(journey_path(second_journey))
              end
            end

            context 'payment_status is unpaid' do
              let(:payment_status) { 'unpaid' }

              it 'does not create a PaidJourney' do
                expect do
                  subject
                end.to change { PaidJourney.count }.by(0)
              end

              it 'does not notify users' do
                expect(Notifiers::BoughtJourney).to_not receive(:new).with(
                  {
                    journey_id: second_journey.id,
                    sender_id: user.id
                  }
                )

                subject
              end

              it 'redirects to journey path' do
                subject

                expect(response.status).to redirect_to(journey_path(second_journey))
              end
            end
          end
        end

        context 'journey is not monetized' do
          before do
            second_journey.update(access_type: :private_journey)
          end

          it_behaves_like 'can not view page'
        end
      end
    end
  end
end
