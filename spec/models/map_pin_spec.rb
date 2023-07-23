# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MapPin, type: :model do
  let(:map_pin) { build(:map_pin) }
  subject { map_pin }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :journey_stop_id }
  it { should have_attribute :user_id }
  it { should have_attribute :lat }
  it { should have_attribute :long }
  it { should have_attribute :title }
  it { should have_attribute :place_id }

  ##################################
  # Associations
  ##################################

  it { should belong_to(:journey_stop).optional(true) }
  it { should belong_to(:user) }

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :lat }
  it { should validate_presence_of :long }
  it { should validate_presence_of :title }
  it { should validate_uniqueness_of(:journey_stop_id).scoped_to(:user_id) }
end
