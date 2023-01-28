# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PelicansController, type: :controller do
  render_views

  let(:user) { create(:user) }

  before do
    sign_in user
  end

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

      expect(response).to redirect_to(edit_pelican_path(user.username))
    end
  end
end
