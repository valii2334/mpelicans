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

  ##################################
  # Associations
  ##################################

  it { should have_many(:paid_journeys).class_name('PaidJourney').dependent(:destroy).inverse_of(:user) }
  it { should have_many(:bought_journeys).through(:paid_journeys).source(:journey) }
  it { should have_many(:journeys).dependent(:destroy) }
  it { should have_many(:map_pins).dependent(:destroy) }
  it { should have_many(:pinned_journey_stops).through(:map_pins).source(:journey_stop) }

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
      it 'returns false' do
        expect(subject.follows?(followee: user2)).to be_falsey
      end
    end
  end

  context '#pinned_journey_stop?' do
    let!(:map_pin) { create :map_pin }

    context 'pinned journey stop' do
      before do
        map_pin.update(user: subject)
      end

      it 'returns true' do
        expect(subject.pinned_journey_stop?(journey_stop: map_pin.journey_stop)).to be_truthy
      end
    end

    context 'not pinned journey stop' do
      it 'returns false' do
        expect(subject.pinned_journey_stop?(journey_stop: map_pin.journey_stop)).to be_falsey
      end
    end
  end

  ##################################
  # Callbacks
  ##################################

  context '#username_validator' do
    before do
      subject.username = username
    end

    context 'contains white space' do
      let(:username) { 'WHITE SPACE' }

      it_behaves_like 'username is not valid'
    end

    context 'contains character other than letter or number' do
      let(:username) { 'VALENTIN@' }

      it_behaves_like 'username is not valid'
    end

    context 'contains only letters and numbers' do
      let(:username) { 'VALENTINLAZAR1' }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end
  end
end
