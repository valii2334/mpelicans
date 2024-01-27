# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesProcessors::Processor do
  let(:imageable)      { create(:journey_stop) }
  let(:image_path)     { 'spec/fixtures/files/madrid.jpg' }
  let(:s3_key)         { "#{SecureRandom.uuid}.jpg" }
  let(:uploaded_image) { create :uploaded_image, imageable:, s3_key: }

  subject do
    described_class.new(imageable_id: imageable.id, imageable_type: imageable.class.name).run
  end

  before do
    Storage.upload(key: uploaded_image.s3_key, file: File.open(image_path))
  end

  after do
    Storage.delete(key: uploaded_image.s3_key)
  end

  it 'resizes and attaches image', :aggregate_failures do
    subject

    imageable.reload

    # It attaches the file to the journey stop
    expect(imageable.images.attachments.size).to eq(1)

    # It deletes the file
    expect { File.open(s3_key) }.to raise_error(Errno::ENOENT)

    # Set image processing status as processed
    expect(imageable.processed?).to be_truthy
  end
end
