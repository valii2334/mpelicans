# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { build(:notification) }
  subject { notification }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :sendee_id }
  it { should have_attribute :sender_id }
  it { should have_attribute :notification_type }
  it { should have_attribute :journey_id }
  it { should have_attribute :journey_stop_id }

  it {
    should define_enum_for(:notification_type).with_values(
      %i[bought_journey new_journey new_journey_stop]
    )
  }

  ##################################
  # Associations
  ##################################

  it { should belong_to(:sendee).class_name('User') }
  it { should belong_to(:sender).class_name('User') }
  it { should belong_to(:journey).optional(true) }
  it { should belong_to(:journey_stop).optional(true) }
end
