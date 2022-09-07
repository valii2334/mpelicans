require 'rails_helper'

RSpec.describe Stop, type: :model do
  let(:stop) { build(:stop) }
  subject { stop }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :title }
  it { should have_attribute :description }
  it { should have_attribute :plus_code }
  it { should have_attribute :journey_id }

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :plus_code }

  ##################################
  # Associations
  ##################################

  it { should belong_to(:journey) }
end
