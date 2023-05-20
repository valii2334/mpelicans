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
  it { should have_attribute :passed_images }
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
    it 'is not valid if number of images is gt MAXIMUM_NUMBER_OF_IMAGES' do
      0.upto(JourneyStop::MAXIMUM_NUMBER_OF_IMAGES - 1).each do |_|
        subject.images << Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg')
      end

      expect(subject).to_not be_valid
      expect(subject.errors.messages).to eq(
        { images: ["can't post more than #{JourneyStop::MAXIMUM_NUMBER_OF_IMAGES} images"] }
      )
    end
  end

  describe '#images_are_present' do
    context 'passed_images is true' do
      before do
        subject.images = []
        subject.passed_images = true
      end

      it 'is valid' do
        expect(subject).to be_valid
      end
    end
  end

  ##################################
  # Associations
  ##################################

  it { should belong_to(:journey) }

  ##################################
  # Methods
  ##################################

  describe '#location_link' do
    it 'returns location_link' do
      expect(subject.location_link).to eq("https://www.plus.codes/#{subject.plus_code}")
    end
  end
end
