# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneyStopImageProcessor do
  let(:journey_stop) { create(:journey_stop) }
  let(:images_paths) { ['spec/fixtures/files/madrid_cp.jpg'] }

  subject do
    described_class.new(journey_stop_id: journey_stop.id, images_paths:).run
  end

  before do
    system(
      "cp #{Rails.root.join('spec/fixtures/files/madrid.jpg')} " \
      "#{Rails.root.join('spec/fixtures/files/madrid_cp.jpg')}"
    )
  end

  it 'resizes and attaches image', :aggregate_failures do
    subject

    journey_stop.reload

    # It attaches the file to the journey stop
    expect(journey_stop.images.attachments.size).to eq(2)

    # It deletes the file
    expect { File.open(images_paths[0]) }.to raise_error(Errno::ENOENT)

    # Set image processing status as processed
    expect(journey_stop.processed?).to be_truthy
  end
end
