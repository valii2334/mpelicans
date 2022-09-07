require 'rails_helper'

RSpec.describe Journey, type: :model do
  let(:journey) { build(:journey) }
  subject { journey }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :title }
  it { should have_attribute :description }
  it { should have_attribute :start_plus_code }
  it { should have_attribute :status }
  it { should have_attribute :access_type }
  it { should have_attribute :accepts_recommendations }
  it { should have_attribute :user_id }
  it { should have_attribute :access_code }

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :start_plus_code }

  ##################################
  # Associations
  ##################################

  it { should belong_to(:user) }
  it { should have_many(:journey_stops) }

  ##################################
  # Callbacks
  ##################################

  context '#add_access_code' do
    it 'adds an access code' do
      user = create(:user)
      journey = Journey.create(title: 'Journey', description: 'First Journey', start_plus_code: '123456', user: user)

      expect(journey.access_code).to_not be_nil
    end
  end

  ##################################
  # Methods
  ##################################

  context '#map_url' do
    context 'journey has no stops' do
      it 'returns map url without destination or waypoints' do
        start_plus_code = 'STARTPLUSCODE'
        journey = create(:journey, start_plus_code: start_plus_code)

        expected_map_url = "https://www.google.com/maps/embed/v1/place?key=#{ENV['GOOGLE_MAPS_API_KEY']}&q=#{start_plus_code}"
        expect(journey.map_url).to eq(expected_map_url)
      end
    end

    context 'journey has one stop' do
      it 'returns map url with origin and destination' do
        start_plus_code = 'STARTPLUSCODE'
        journey = create(:journey, start_plus_code: start_plus_code)
        plus_code = 'PLUSCODE'
        journey_stop = create(:journey_stop, journey: journey, plus_code: plus_code)

        expected_map_url = "https://www.google.com/maps/embed/v1/directions?key=#{ENV['GOOGLE_MAPS_API_KEY']}&origin=#{start_plus_code}&destination=#{plus_code}"
        expect(journey.map_url).to eq(expected_map_url)
      end
    end

    context 'journey has at least two stops' do
      it 'returns map url with origin, destination and waypoints' do
        start_plus_code = 'STARTPLUSCODE'
        journey = create(:journey, start_plus_code: start_plus_code)
        plus_code = 'PLUSCODE'
        journey_stop = create(:journey_stop, journey: journey, plus_code: plus_code)
        second_plus_code = 'PLUSCODESECOND'
        second_journey_stop = create(:journey_stop, journey: journey, plus_code: second_plus_code)
        third_plus_code = 'PLUSCODETHIRD'
        third_journey_stop = create(:journey_stop, journey: journey, plus_code: third_plus_code)

        expected_map_url = "https://www.google.com/maps/embed/v1/directions?key=#{ENV['GOOGLE_MAPS_API_KEY']}&origin=#{start_plus_code}&destination=#{third_plus_code}&waypoints=#{plus_code}|#{second_plus_code}"
        expect(journey.map_url).to eq(expected_map_url)
      end
    end
  end
end
