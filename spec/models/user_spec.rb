# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  subject { user }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :email }
  it { should have_attribute :username }

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :username }
  it { should validate_uniqueness_of(:username).case_insensitive }

  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email).case_insensitive }

  ##################################
  # Associations
  ##################################

  it { should have_many(:paid_journeys).class_name('PaidJourney').dependent(:destroy).inverse_of(:user) }
  it { should have_many(:bought_journeys).through(:paid_journeys).source(:journey) }
  it { should have_many(:journeys).dependent(:destroy) }

  it {
    should have_many(:followed_users)
      .with_foreign_key(:follower_id)
      .class_name('Relationship')
      .dependent(:destroy)
      .inverse_of(:follower)
  }
  it { should have_many(:followees).through(:followed_users) }

  it {
    should have_many(:following_users)
      .with_foreign_key(:followee_id)
      .class_name('Relationship')
      .dependent(:destroy)
      .inverse_of(:followee)
  }
  it { should have_many(:followers).through(:following_users) }

  it {
    should have_many(:received_notifications)
      .with_foreign_key(:receiver_id)
      .class_name('Notification')
      .dependent(:destroy)
      .inverse_of(:receiver)
  }

  ##################################
  # Methods
  ##################################

  context '#public_viewable_journeys' do
    let(:user) { create(:user) }
    let!(:public_journey)    { create(:journey, access_type: :public_journey, user:) }
    let!(:private_journey)   { create(:journey, access_type: :private_journey, user:) }
    let!(:monetized_journey) { create(:journey, access_type: :monetized_journey, user:) }
    let!(:protected_journey) { create(:journey, access_type: :protected_journey, user:) }

    it 'returns only public and monetized journeys' do
      expect(user.public_viewable_journeys).to match_array([public_journey, monetized_journey])
    end
  end

  context '#bought_journey?' do
    let!(:journey1) { create :journey }
    let!(:journey2) { create :journey }
    let!(:bought_journey) { create :paid_journey, user: subject, journey: journey1 }

    context 'bought journey' do
      it 'returns true' do
        expect(subject.bought_journey?(journey: journey1)).to be_truthy
      end
    end

    context 'did not bought journey' do
      it 'returns false' do
        expect(subject.bought_journey?(journey: journey2)).to be_falsey
      end
    end
  end

  context '#follows?' do
    let!(:user1) { create :user }
    let!(:user2) { create :user }
    let!(:follower) { create :relationship, follower: subject, followee: user1 }

    context 'follows user' do
      it 'returns true' do
        expect(subject.follows?(followee: user1)).to be_truthy
      end
    end

    context 'does not follow user' do
      it 'returns true' do
        expect(subject.follows?(followee: user2)).to be_falsey
      end
    end
  end

  ##################################
  # Callbacks
  ##################################

  context '#username_validator' do
    it 'validates that a username does not contain white space characters', :aggregate_failures do
      user = build(:user, username: 'WHITE SPACE')

      expect(user.valid?).to be_falsey
      expect(user.errors.full_messages).to include('Username can not contain special characters')
    end
  end
end
