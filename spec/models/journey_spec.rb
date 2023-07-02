# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Journey, type: :model do
  let(:journey) { build(:journey) }
  subject { journey }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :title }
  it { should have_attribute :description }
  it { should have_attribute :access_type }
  it { should have_attribute :accepts_recommendations }
  it { should have_attribute :user_id }
  it { should have_attribute :access_code }
  it { should have_attribute :lat }
  it { should have_attribute :long }

  ##################################
  # ENUMS
  ##################################

  it do
    should define_enum_for(:access_type).with_values(
      %i[private_journey protected_journey public_journey monetized_journey]
    )
  end

  it do
    should define_enum_for(:image_processing_status).with_values(
      %i[waiting processing processed]
    )
  end

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :lat }
  it { should validate_presence_of :long }
  it { should validate_presence_of :title }

  it_behaves_like '#images_are_present'

  ##################################
  # Associations
  ##################################

  it { should belong_to(:user) }
  it { should have_many(:journey_stops).dependent(:destroy) }
  it { should have_many(:paid_journeys).dependent(:destroy) }
  it { should have_many(:notifications).dependent(:destroy) }
  it { should have_many(:paying_users).through(:paid_journeys).source(:user) }
  it { should have_many(:uploaded_images).dependent(:destroy) }

  ##################################
  # Callbacks
  ##################################

  context '#add_access_code' do
    before do
      subject.save
    end

    it 'adds an access code' do
      expect(subject.access_code).to_not be_nil
    end
  end

  ##################################
  # Methods
  ##################################

  context '#link_to_self' do
    before do
      subject.save
    end

    it 'returns full url to self' do
      expect(subject.link_to_self).to eq(nil)
    end
  end

  context '#pins' do
    before do
      subject.save
    end

    let!(:journey_stop0) { create(:journey_stop, journey: subject) }
    let!(:journey_stop1) { create(:journey_stop, journey: subject) }

    it 'returns all pins' do
      expect(subject.pins).to match_array(
        [
          Pin.new(pinnable: subject).to_pin,
          Pin.new(pinnable: journey_stop0).to_pin,
          Pin.new(pinnable: journey_stop1).to_pin
        ]
      )
    end
  end
end
