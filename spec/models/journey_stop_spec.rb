# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneyStop, type: :model do
  let(:journey_stop) { build(:journey_stop) }
  subject { journey_stop }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :title }
  it { should have_attribute :description }
  it { should have_attribute :image_processing_status }
  it { should have_attribute :passed_images_count }
  it { should have_attribute :lat }
  it { should have_attribute :long }
  it { should have_attribute :journey_id }
  it { should have_attribute :lat }
  it { should have_attribute :long }

  ##################################
  # ENUMS
  ##################################

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

  describe '#maximum_number_of_images' do
    it 'is not valid if passed_images_count is gt than MAXIMUM_NUMBER_OF_IMAGES' do
      subject.passed_images_count = JourneyStop::MAXIMUM_NUMBER_OF_IMAGES + 1

      expect(subject).to_not be_valid
      expect(subject.errors.messages).to eq(
        { images: ["can't post more than #{JourneyStop::MAXIMUM_NUMBER_OF_IMAGES}"] }
      )
    end

    it 'is valid if passed_images_count is l or e than MAXIMUM_NUMBER_OF_IMAGES' do
      subject.passed_images_count = JourneyStop::MAXIMUM_NUMBER_OF_IMAGES

      expect(subject).to be_valid
    end
  end

  it_behaves_like '#images_are_present'

  ##################################
  # Callbacks
  ##################################

  ##################################
  # Associations
  ##################################

  it { should belong_to(:journey) }
  it { should have_many(:uploaded_images).dependent(:destroy) }
  it { should have_many(:notifications).dependent(:destroy) }

  ##################################
  # Methods
  ##################################

  context '#link_to_self' do
    before do
      subject.save
    end

    it 'returns full url to self' do
      expected_url = "https://www.mpelicans.com/journeys/#{subject.journey.id}/journey_stops/#{subject.id}"

      expect(subject.link_to_self).to eq(expected_url)
    end
  end
end
