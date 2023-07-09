# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesProcessors::Uploader do
  let(:imageable)         { create :journey }
  let(:imageable_id)      { imageable.id }
  let(:imageable_type)    { imageable.class.name }
  let(:saved_file_path)   { Rails.root.join("tmp/#{SecureRandom.uuid}.jpg").to_s }
  let(:saved_files_paths) { [saved_file_path] }

  subject { described_class.new(imageable_id:, imageable_type:, saved_files_paths:) }

  before do
    allow(JourneyJobs::ProcessImages).to receive(:perform_async).with(imageable_id, imageable_type)

    File.binwrite(saved_file_path, File.read('spec/fixtures/files/lasvegas.jpg'))

    allow(subject).to receive(:upload_image).with(key: File.basename(saved_file_path),
                                                  body: File.read(saved_file_path))
  end

  context '#run_processor' do
    it 'uploads the image' do
      expect(subject).to receive(:upload_image).with(key: File.basename(saved_file_path),
                                                     body: File.read(saved_file_path))

      subject.run_processor
    end

    it 'removes the file locally' do
      subject.run_processor

      expect(File.exist?(saved_file_path)).to be_falsey
    end

    it 'creates an UploadedImage with the right arguments for imageable' do
      subject.run_processor

      expect(imageable.uploaded_images.count).to eq(1)
      expect(imageable.uploaded_images.first.s3_key).to eq(File.basename(saved_file_path))
    end

    context '#enque_next_steps' do
      it 'calls JourneyJobs::ProcessImages.perform_async with desired arguments' do
        expect(JourneyJobs::ProcessImages).to receive(:perform_async).with(imageable_id, imageable_type)

        subject.run
      end
    end
  end
end
