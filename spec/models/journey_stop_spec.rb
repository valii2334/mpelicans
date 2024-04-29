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
  it { should have_attribute :views_count }
  it { should have_attribute :place_id }

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

  context '#set_latest_journey_stop_added_at' do
    let(:old_latest_journey_stop_added_at) { DateTime.new(2022, 1, 1, 10, 0, 0) }
    let(:expected_datetime) { DateTime.new(2023, 1, 1, 10, 0, 0) }

    before do
      allow(DateTime).to receive(:now).and_return(expected_datetime)

      subject.journey.update(latest_journey_stop_added_at: old_latest_journey_stop_added_at)
    end

    it 'sets latest_journey_stop_added_at' do
      expect { subject.save }.to change {
        subject.journey.latest_journey_stop_added_at
      }.from(old_latest_journey_stop_added_at).to(expected_datetime)
    end
  end

  ##################################
  # Associations
  ##################################

  it { should belong_to(:journey) }
  it { should have_many(:uploaded_images).dependent(:destroy) }
  it { should have_many(:notifications).dependent(:destroy) }
  it { should have_many(:map_pins).dependent(:nullify) }

  ##################################
  # Methods
  ##################################

  context '#link_to_self' do
    before do
      subject.save
    end

    it 'returns full url to self' do
      expected_url = "http://#{ENV.fetch('DEFAULT_HOST')}/journeys/#{subject.journey.id}?scroll_to=#{subject.anchor_id}"

      expect(subject.link_to_self).to eq(expected_url)
    end
  end

  context '#link_to_google_maps' do
    context 'without place_id' do
      let(:link_to_google_maps) { "https://www.google.com/maps/search/?api=1&query=#{subject.lat},#{subject.long}" }

      it 'returns a link to place id' do
        expect(subject.link_to_google_maps).to eq(link_to_google_maps)
      end
    end

    context 'with place_id' do
      before do
        subject.update(place_id: 'place_id')
      end

      let(:link_to_google_maps) { 'https://www.google.com/maps/search/?api=1&query=Google&query_place_id=place_id' }

      it 'returns a pin' do
        expect(subject.link_to_google_maps).to eq(link_to_google_maps)
      end
    end
  end

  context '#pin' do
    before do
      subject.save
    end

    it 'returns the pin' do
      expect(subject.pin).to eq(Pin.new(pinnable: subject).to_pin)
    end
  end
end
