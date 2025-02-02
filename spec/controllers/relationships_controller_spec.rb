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
      post :create, params: { followee_id: }
    end

    context 'I try to follow me' do
      let(:followee_id) { user.id }

      it 'should raise an error' do
        expect do
          subject
        end.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'I try follow a user which I am not following yet' do
      let(:followee_id) { second_user.id }

      it 'should create a new relationship object' do
        expect do
          subject
        end.to change { Relationship.count }.by(1)
      end

      let(:notifier) { double('Notifiers::NewFollower') }

      before do
        allow(Notifiers::NewFollower).to receive(:new).and_return(notifier)
        allow(notifier).to receive(:notify).and_return(nil)
      end

      it 'does notify users' do
        subject

        expect(Notifiers::NewFollower)
          .to have_received(:new).with({
                                         receiver_id: followee_id.to_s,
                                         sender_id: user.id
                                       })
      end
    end

    context 'I try to follow a user which I am already following' do
      let(:followee_id) { second_user.id }

      before do
        create(:relationship, follower: user, followee: second_user)
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
      context 'I am the follower' do
        let(:relationship) { create(:relationship, follower: user, followee: second_user) }
        let!(:relationship_id) { relationship.id }

        it 'should destroy the relationship' do
          expect do
            subject
          end.to change { Relationship.count }.by(-1)
        end
      end

      context 'I am the followee' do
        let(:relationship) { create(:relationship, follower: second_user, followee: user) }
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
