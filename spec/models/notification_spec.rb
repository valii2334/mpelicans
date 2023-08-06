# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  include Rails.application.routes.url_helpers

  let(:notification) { build(:notification) }
  subject { notification }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :sender_id }
  it { should have_attribute :read }
  it { should have_attribute :receiver_id }
  it { should have_attribute :type }
  it { should have_attribute :journey_id }
  it { should have_attribute :journey_stop_id }

  ##################################
  # Associations
  ##################################

  it { should belong_to(:sender).class_name('User') }
  it { should belong_to(:receiver).class_name('User') }
  it { should belong_to(:journey).optional(true) }
  it { should belong_to(:journey_stop).optional(true) }

  ##################################
  # Methods
  ##################################

  context '#notification_title' do
    it 'raises NotImplemented' do
      expect { subject.notification_title }.to raise_error(NotImplementedError)
    end
  end

  context '#notification_link' do
    it 'raises NotImplemented' do
      expect { subject.notification_link }.to raise_error(NotImplementedError)
    end
  end

  context '#notification_text' do
    it 'raises NotImplemented' do
      expect { subject.notification_text }.to raise_error(NotImplementedError)
    end
  end
end
