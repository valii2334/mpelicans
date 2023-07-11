# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JourneyJobs::UploadImages, type: :job do
  let(:imageable_id)      { rand(1..99) }
  let(:imageable_type)    { 'Journey' }
  let(:database_images_ids) { [rand(1..99)] }

  subject { described_class.new.perform(imageable_id, imageable_type, database_images_ids) }

  let(:images_processors_uploader) { double('ImagesProcessors::Uploader') }

  before do
    allow(ImagesProcessors::Uploader).to(
      receive(:new).with(imageable_id:, imageable_type:, database_images_ids:)
                   .and_return(images_processors_uploader)
    )
    allow(images_processors_uploader).to receive(:run)
  end

  it 'calls ImagesProcessors::Uploader' do
    expect(ImagesProcessors::Uploader).to(
      receive(:new).with(imageable_id:, imageable_type:, database_images_ids:)
    )

    subject
  end
end
