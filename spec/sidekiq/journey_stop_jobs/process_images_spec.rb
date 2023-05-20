# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneyStopJobs::ProcessImages, type: :job do
  let(:journey_stop_id) { rand(1..99) }
  let(:images_paths) { [FFaker::Name.name, FFaker::Name.name] }

  subject { described_class.new.perform(journey_stop_id, images_paths) }

  let(:journey_stop_image_processor) { double('JourneyStopImageProcessor') }

  before do
    allow(JourneyStopImageProcessor).to(
      receive(:new).with(journey_stop_id:, images_paths:)
                   .and_return(journey_stop_image_processor)
    )
    allow(journey_stop_image_processor).to receive(:run)
  end

  it 'calls JourneyStopImageProcessor' do
    expect(JourneyStopImageProcessor).to(
      receive(:new).with(journey_stop_id:, images_paths:)
    )

    subject
  end
end
