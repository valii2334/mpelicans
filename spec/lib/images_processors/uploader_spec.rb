# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesProcessors::Uploader do
  let(:imageable)           { create :journey }
  let(:imageable_id)        { imageable.id }
  let(:imageable_type)      { imageable.class.name }
  let(:http_uploaded_file)  { Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg') }
  let(:http_uploaded_files) { [http_uploaded_file] }
  let(:secure_random_uuid)  { SecureRandom.uuid }
  let(:file_path)           { "#{secure_random_uuid}.jpg" }
  let(:file_data)           { http_uploaded_file.tempfile.open.read }

  subject { described_class.new(imageable_id:, imageable_type:, http_uploaded_files:) }

  before do
    allow(SecureRandom).to receive(:uuid).and_return(secure_random_uuid)
    allow(JourneyJobs::ProcessImages).to receive(:perform_async).with(imageable_id, imageable_type)

    allow(subject).to receive(:upload_image).with(key: file_path, body: file_data)
  end

  context '#run_processor' do
    it 'uploads the image' do
      expect(subject).to receive(:upload_image).with(key: file_path,
                                                     body: file_data)

      subject.run_processor
    end

    it 'creates an UploadedImage with the right arguments for imageable' do
      subject.run_processor

      expect(imageable.uploaded_images.count).to eq(1)
      expect(imageable.uploaded_images.first.s3_key).to eq(file_path)
    end

    context '#enque_next_steps' do
      it 'calls JourneyJobs::ProcessImages.perform_async with desired arguments' do
        expect(JourneyJobs::ProcessImages).to receive(:perform_async).with(imageable_id, imageable_type)

        subject.run
      end
    end
  end
end
