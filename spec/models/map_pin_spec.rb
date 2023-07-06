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

  ##################################
  # Associations
  ##################################

  it { should belong_to(:journey_stop).optional(true) }
  it { should belong_to(:user) }
end
