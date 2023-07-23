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
  it { should have_attribute :views_count }

  ##################################
  # ENUMS
  ##################################

  it do
    should define_enum_for(:access_type).with_values(
      %i[public_journey protected_journey private_journey monetized_journey]
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

  context '#set_latest_journey_stop_added_at' do
    let(:expected_datetime) { DateTime.new(2023, 1, 1, 10, 0, 0) }

    before do
      allow(DateTime).to receive(:now).and_return(expected_datetime)
    end

    it 'sets latest_journey_stop_added_at' do
      expect { subject.save }.to change {
        subject.latest_journey_stop_added_at
      }.from(NilClass).to(expected_datetime)
    end
  end

  ##################################
  # Methods
  ##################################

  context '#lastest_journey_stop_id' do
    before do
      subject.save
    end

    let!(:journey_stop01) { create :journey_stop, journey: subject, created_at: DateTime.now }
    let!(:journey_stop02) { create :journey_stop, journey: subject, created_at: DateTime.now + 1.day }

    it 'returns latest journey_stop id' do
      expect(subject.lastest_journey_stop_id).to eq(journey_stop02.id)
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
          Pin.new(pinnable: journey_stop0).to_pin,
          Pin.new(pinnable: journey_stop1).to_pin
        ]
      )
    end
  end
end
