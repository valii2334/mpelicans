# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:third_user) { create(:user) }

  before do
    sign_in user
  end

  context '#create' do
    subject do
      post :create, params: { follower_id: follower_id }
    end

    context 'I try to follow me' do
      let(:follower_id) { user.id }

      it 'should raise an error' do
        expect do
          subject
        end.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'I try follow a user which I am not following yet' do
      let(:follower_id) { second_user.id }

      it 'should create a new relationship object' do
        expect do
          subject
        end.to change { Relationship.count }.by(1)
      end
    end

    context 'I try to follow a user which I am already following' do
      let(:follower_id) { second_user.id }

      before do
        create(:relationship, followee: user, follower: second_user)
      end

      it 'should raise an error' do
        expect do
          subject
        end.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  context '#destroy' do
    subject do
      delete :destroy, params: { id: relationship_id }
    end

    context 'authorization' do
      let(:relationship) { create(:relationship, followee: second_user, follower: third_user) }
      let(:relationship_id) { relationship.id }

      it 'can not destroy other users relationship' do
        expect do
          subject
        end.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'my relationship' do
      context 'I am the followee' do
        let(:relationship) { create(:relationship, followee: user, follower: second_user) }
        let!(:relationship_id) { relationship.id }

        it 'should destroy the relationship' do
          expect do
            subject
          end.to change { Relationship.count }.by(-1)
        end
      end

      context 'I am the follower' do
        let(:relationship) { create(:relationship, followee: second_user, follower: user) }
        let!(:relationship_id) { relationship.id }

        it 'can not destroy it' do
          expect do
            subject
          end.to raise_error(CanCan::AccessDenied)
        end
      end
    end
  end
end
