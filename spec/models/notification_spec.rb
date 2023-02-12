# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { build(:notification) }
  subject { notification }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :sender_id }
  it { should have_attribute :receiver_id }
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

  it { should belong_to(:sender).class_name('User') }
  it { should belong_to(:receiver).class_name('User') }
  it { should belong_to(:journey) }
  it { should belong_to(:journey_stop).optional(true) }

  ##################################
  # Validations
  ##################################

  context '#journey_stop' do
    let(:notification) { build(:notification, notification_type: :new_journey_stop, journey_stop:) }

    context 'missing journey_stop' do
      let(:journey_stop) { nil }

      it 'is not valid' do
        expect(notification).to_not be_valid
      end
    end

    context 'has journey_stop' do
      let(:journey_stop) { create(:journey_stop) }

      it 'is not valid' do
        expect(notification).to be_valid
      end
    end
  end
end
