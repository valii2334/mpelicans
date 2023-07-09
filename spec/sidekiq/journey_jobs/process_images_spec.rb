# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneyJobs::ProcessImages, type: :job do
  let(:imageable_id) { rand(1..99) }
  let(:imageable_type) { 'Journey' }

  subject { described_class.new.perform(imageable_id, imageable_type) }

  let(:journey_image_processor) { double('JourneyImageProcessor') }

  before do
    allow(JourneyImageProcessor).to(
      receive(:new).with(imageable_id:, imageable_type:)
                   .and_return(journey_image_processor)
    )
    allow(journey_image_processor).to receive(:run)
  end

  it 'calls JourneyImageProcessor' do
    expect(JourneyImageProcessor).to(
      receive(:new).with(imageable_id:, imageable_type:)
    )

    subject
  end
end
