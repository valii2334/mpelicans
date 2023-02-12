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
  it { should have_attribute :start_plus_code }
  it { should have_attribute :access_type }
  it { should have_attribute :accepts_recommendations }
  it { should have_attribute :user_id }
  it { should have_attribute :access_code }

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :description }
  it { should validate_presence_of :start_plus_code }
  it { should validate_presence_of :title }

  ##################################
  # Associations
  ##################################

  it { should belong_to(:user) }
  it { should have_many(:journey_stops).dependent(:destroy) }
  it { should have_many(:paid_journeys).dependent(:destroy) }
  it { should have_many(:paying_users).through(:paid_journeys).source(:user) }

  ##################################
  # Callbacks
  ##################################

  context '#add_access_code' do
    it 'adds an access code' do
      journey = create(:journey)

      expect(journey.access_code).to_not be_nil
    end
  end

  ##################################
  # Methods
  ##################################

  context '#origin' do
    it 'returns origin' do
      expect(subject.send(:origin)).to eq(subject.start_plus_code)
    end
  end

  context '#destination' do
    context 'journey has no journey stops' do
      before do
        allow(subject).to receive(:journey_stops).and_return([])
      end

      it 'returns nil' do
        expect(subject.send(:destination)).to eq(nil)
      end
    end

    context 'journey has multiple journey stops' do
      before do
        allow(subject).to receive(:journey_stops).and_return(
          [
            double('JourneyStop1', plus_code: 'PlusCode1'),
            double('JourneyStop2', plus_code: 'PlusCode2')
          ]
        )
      end

      it 'returns last journey stops plus code' do
        expect(subject.send(:destination)).to eq('PlusCode2')
      end
    end
  end

  context '#waypoints' do
    context 'journey has no journey stops' do
      before do
        allow(subject).to receive(:journey_stops).and_return([])
      end

      it 'returns []' do
        expect(subject.send(:waypoints)).to eq([])
      end
    end

    context 'journey has multiple journey stops' do
      let(:journey_stop1) { double('JourneyStop1') }
      let(:journey_stop2) { double('JourneyStop2') }

      before do
        allow(journey_stop1).to receive(:[]).with(:plus_code).and_return('PlusCode1')
        allow(journey_stop2).to receive(:[]).with(:plus_code).and_return('PlusCode2')

        allow(subject).to receive(:journey_stops).and_return(
          [
            journey_stop1,
            journey_stop2
          ]
        )
      end

      it 'returns last journey stops plus code' do
        expect(subject.send(:waypoints)).to eq(['PlusCode1'])
      end
    end
  end
end
