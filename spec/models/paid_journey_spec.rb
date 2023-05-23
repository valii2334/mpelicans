# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaidJourney, type: :model do
  let(:paid_journey) { build(:paid_journey) }
  subject { paid_journey }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :user_id }
  it { should have_attribute :journey_id }

  ##################################
  # Associations
  ##################################

  it { should belong_to(:user) }
  it { should belong_to(:journey) }

  ##################################
  # Validations
  ##################################

  it { should validate_uniqueness_of(:journey_id).scoped_to(:user_id) }
end
