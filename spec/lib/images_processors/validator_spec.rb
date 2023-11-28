# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesProcessors::Validator do
  let(:imageable_id)        { SecureRandom.uuid }
  let(:imageable_type)      { SecureRandom.uuid }
  let(:image_file)          { Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg') }
  let(:text_file)           { Rack::Test::UploadedFile.new('spec/fixtures/files/text.txt', 'text/txt') }
  let(:http_uploaded_files) { [image_file, text_file] }

  subject { described_class.new(imageable_id:, imageable_type:, http_uploaded_files:) }

  let(:images_processor_uploader) { double('ImagesProcessor::Uploader') }

  before do
    allow(ImagesProcessors::Uploader).to receive(:new).with(
      imageable_id:, imageable_type:,
      http_uploaded_files: [image_file]
    ).and_return(images_processor_uploader)
    allow(images_processor_uploader).to receive(:run)
  end

  context '#run_processor' do
    it 'returns only images' do
      expect(subject.run_processor).to match_array([image_file])
    end
  end

  context '#enque_next_steps' do
    it 'calls ImagesProcessors::Saver with desired arguments' do
      expect(ImagesProcessors::Uploader).to receive(:new).with(imageable_id:, imageable_type:,
                                                               http_uploaded_files: [image_file])
      expect(images_processor_uploader).to receive(:run)

      subject.run
    end
  end
end
