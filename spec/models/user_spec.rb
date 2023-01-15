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
  it { should validate_uniqueness_of :username }

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

  ##################################
  # Callbacks
  ##################################

  context '#username_validator' do
    it 'validates that a username does not contain white space characters', :aggregate_failures do
      user = build(:user, username: 'WHITE SPACE')

      expect(user.valid?).to be_falsey
      expect(user.errors.full_messages).to include('Username can not contain white spaces')
    end
  end
end
