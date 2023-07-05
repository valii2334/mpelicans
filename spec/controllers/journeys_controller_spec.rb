# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneysController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:journey) { create(:journey, user:) }
  let(:second_user) { create(:user) }
  let(:second_journey) { create(:journey, user: second_user) }

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
      end

      context 'protected_journey' do
        before do
          second_journey.update(access_type: :protected_journey)
        end

        context 'params contain access_code' do
          it_behaves_like 'can view page'
        end

        context 'params does not contain access_code' do
          subject do
            get :show, params: { id: journey_id }
          end

          it_behaves_like 'can not view page'
        end
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
      context 'for current user' do
        context 'invalid parameters' do
          context 'missing title' do
            let(:journey_params) do
              {
                description: FFaker::Lorem.paragraph,
                images: fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
                lat: '46.749971',
                long: '23.598739',
                user_id: user.id
              }
            end

            include_examples 'missing parameter', Journey, 'Title'
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

            include_examples 'missing parameter', Journey, 'Images'
          end

          context 'missing lat' do
            let(:journey_params) do
              {
                description: FFaker::Lorem.paragraph,
                images: fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
                long: '23.598739',
                title: FFaker::Name.name,
                user_id: user.id
              }
            end

            include_examples 'missing parameter', Journey, 'Lat'
          end

          context 'missing long' do
            let(:journey_params) do
              {
                description: FFaker::Lorem.paragraph,
                images: fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
                lat: '46.749971',
                title: FFaker::Name.name,
                user_id: user.id
              }
            end

            include_examples 'missing parameter', Journey, 'Long'
          end
        end

        context 'valid parameters' do
          let(:access_type) { :public_journey }

          let(:journey_params) do
            {
              access_type:,
              description: FFaker::Lorem.paragraph,
              images: fixture_file_upload('lasvegas.jpg', 'image/jpeg'),
              lat: '46.749971',
              long: '23.598739',
              title: FFaker::Name.name,
              user_id: user.id
            }
          end

          it 'creates journey' do
            expect do
              subject
            end.to change { Journey.count }.by(1)
          end

          let(:notifier) { double('Notifier') }

          before do
            allow(notifier).to receive(:notify).and_return(nil)
          end

          context 'protected, private journey' do
            %i[protected_journey private_journey].each do |access_type|
              let(:access_type) { access_type }

              it 'does not notify users' do
                subject
              end
            end
          end

          context 'public, monetized journey' do
            %i[public_journey monetized_journey].each do |access_type|
              let(:access_type) { access_type }

              it 'does notify users' do
                expect(Notifier).to receive(:new).with({
                                                         journey_id: instance_of(Integer),
                                                         notification_type: :new_journey,
                                                         sender_id: user.id
                                                       }).and_return(notifier)
                subject
              end
            end
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
end
