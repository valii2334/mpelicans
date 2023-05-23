# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneyStopJobs::ProcessImages, type: :job do
  let(:journey_stop_id) { rand(1..99) }

  subject { described_class.new.perform(journey_stop_id) }

  let(:journey_stop_image_processor) { double('JourneyStopImageProcessor') }

  before do
    allow(JourneyStopImageProcessor).to(
      receive(:new).with(journey_stop_id:)
                   .and_return(journey_stop_image_processor)
    )
    allow(journey_stop_image_processor).to receive(:run)
  end

  it 'calls JourneyStopImageProcessor' do
    expect(JourneyStopImageProcessor).to(
      receive(:new).with(journey_stop_id:)
    )

    subject
  end
end
