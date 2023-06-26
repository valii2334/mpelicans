# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:relationship) { build(:relationship) }
  subject { relationship }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :follower_id }
  it { should have_attribute :followee_id }

  ##################################
  # Associations
  ##################################

  it { should belong_to(:follower).class_name('User') }
  it { should belong_to(:followee).class_name('User') }

  ##################################
  # Validations
  ##################################

  context '#different_follower_followee' do
    context 'same follower and followee' do
      before do
        subject.followee = subject.follower
      end

      it 'is not valid' do
        expect(subject).to_not be_valid
      end

      it 'adds proper error message' do
        subject.valid?

        expect(subject.errors.full_messages).to match_array('can not follow yourself')
      end
    end
  end
end
