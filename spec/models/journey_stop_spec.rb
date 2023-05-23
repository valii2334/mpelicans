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
  it { should have_attribute :plus_code }
  it { should have_attribute :journey_id }

  # ENUMS

  it do
    should define_enum_for(:image_processing_status).with_values(
      %i[waiting processing processed]
    )
  end

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :plus_code }

  describe '#maximum_number_of_images' do
    it 'is not valid if passed_images_count is gt than MAXIMUM_NUMBER_OF_IMAGES' do
      subject.passed_images_count = JourneyStop::MAXIMUM_NUMBER_OF_IMAGES + 1

      expect(subject).to_not be_valid
      expect(subject.errors.messages).to eq(
        { images: ["can't post more than #{JourneyStop::MAXIMUM_NUMBER_OF_IMAGES} images"] }
      )
    end

    it 'is valid if passed_images_count is l or e than MAXIMUM_NUMBER_OF_IMAGES' do
      subject.passed_images_count = JourneyStop::MAXIMUM_NUMBER_OF_IMAGES

      expect(subject).to be_valid
    end
  end

  describe '#images_are_present' do
    context 'passed_images_count is gt than 0' do
      before do
        subject.passed_images_count = 1
      end

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'passed_images_count is 0' do
      before do
        subject.passed_images_count = 0
      end

      it 'it is not valid', :aggregate_failures do
        expect(subject).to_not be_valid
        expect(subject.errors.messages).to eq(
          { images: ["can't be blank"] }
        )
      end
    end
  end

  ##################################
  # Associations
  ##################################

  it { should belong_to(:journey) }
  it { should have_many(:uploaded_images) }

  ##################################
  # Methods
  ##################################

  describe '#location_link' do
    it 'returns location_link' do
      expect(subject.location_link).to eq("https://www.plus.codes/#{subject.plus_code}")
    end
  end
end
