# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PelicansController, type: :controller do
  render_views

  let(:user) { create(:user) }

  RSpec.shared_examples 'pelicans index' do
    context '#index' do
      it 'is successful' do
        get :index

        expect(response).to be_successful
      end
    end
  end

  RSpec.shared_examples 'pelicans show' do
    context '#show' do
      context 'user exists' do
        let!(:user0) { create :user }

        it 'is successful' do
          get :show, params: { username: user.username }

          expect(response).to be_successful
        end
      end

      context 'user does not exist' do
        it 'raises an error' do
          expect { get :show, params: { username: SecureRandom.uuid } }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  context 'not logged in' do
    it_behaves_like 'pelicans index'
    it_behaves_like 'pelicans show'

    context '#edit' do
      it 'to be redirected' do
        get :edit, params: { username: user.username }

        expect(response.status).to eq(302)
      end
    end

    context '#update' do
      let(:new_biography) { FFaker::Lorem.sentence }

      it 'biography, image and username', aggregate: :failures do
        patch :update, params: {
          username: user.username,
          user: {
            biography: new_biography
          }
        }

        user.reload

        expect(response.status).to eq(302)
        expect(user.biography).to_not eq(new_biography)
      end
    end
  end

  context 'logged in' do
    before do
      sign_in user
    end

    it_behaves_like 'pelicans index'
    it_behaves_like 'pelicans show'

    context '#edit' do
      it 'returns 200' do
        get :edit, params: { username: user.username }

        expect(response).to be_successful
      end
    end

    context '#update' do
      let(:new_biography) { FFaker::Lorem.sentence }
      let(:new_image)     { Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg') }
      let(:new_username)  { FFaker::Lorem.word }
      let(:new_password)  { FFaker::Lorem.sentence }

      it 'biography, image and username', aggregate: :failures do
        patch :update, params: {
          username: user.username,
          user: {
            biography: new_biography,
            image: new_image,
            username: new_username
          }
        }

        user.reload

        expect(user.biography).to eq(new_biography)
        expect(user.image.filename.to_s).to eq('lasvegas.jpg')
        expect(user.username).to eq(new_username)
      end

      it 'updates password' do
        patch :update, params: {
          username: user.username,
          user: {
            password: new_password,
            password_confirmation: new_password
          }
        }

        user.reload

        expect(response).to be_successful
        expect(user.valid_password?(new_password)).to be_truthy
      end
    end
  end
end
