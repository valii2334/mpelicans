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
end
