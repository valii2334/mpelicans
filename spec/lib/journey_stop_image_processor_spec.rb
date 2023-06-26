# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneyStopImageProcessor do
  let(:journey_stop)   { create(:journey_stop) }
  let(:image_path)     { 'spec/fixtures/files/madrid.jpg' }
  let(:s3_key)         { "test-#{journey_stop.id}-#{SecureRandom.uuid}#{File.extname(image_path)}" }
  let(:uploaded_image) { create :uploaded_image, imageable: journey_stop, s3_key: }

  subject do
    described_class.new(journey_stop_id: journey_stop.id).run
  end

  before do
    Storage.upload(key: uploaded_image.s3_key, body: File.open(image_path))
  end

  after do
    Storage.delete(key: uploaded_image.s3_key)
  end

  it 'resizes and attaches image', :aggregate_failures do
    subject

    journey_stop.reload

    # It attaches the file to the journey stop
    expect(journey_stop.images.attachments.size).to eq(1)

    # It deletes the file
    expect { File.open(s3_key) }.to raise_error(Errno::ENOENT)

    # Set image processing status as processed
    expect(journey_stop.processed?).to be_truthy
  end
end
