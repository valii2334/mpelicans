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

  it { should have_many(:paid_journeys).dependent(:destroy) }
  it { should have_many(:journeys).dependent(:destroy) }

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
