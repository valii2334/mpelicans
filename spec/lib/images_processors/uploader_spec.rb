# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesProcessors::Uploader do
  let(:imageable)           { create :journey }
  let(:imageable_id)        { imageable.id }
  let(:imageable_type)      { imageable.class.name }
  let(:database_image)      { create :database_image }
  let(:database_images_ids) { [database_image.id] }
  let(:secure_random_uuid)  { SecureRandom.uuid }
  let(:file_path)           { "#{secure_random_uuid}#{database_image.file_extension}" }
  let(:file_data)           { database_image.data }

  subject { described_class.new(imageable_id:, imageable_type:, database_images_ids:) }

  before do
    allow(SecureRandom).to receive(:uuid).and_return(secure_random_uuid)
    allow(JourneyJobs::ProcessImages).to receive(:perform_async).with(imageable_id, imageable_type)

    allow(subject).to receive(:upload_image).with(key: file_path,
                                                  body: file_data)
  end

  context '#run_processor' do
    it 'uploads the image' do
      expect(subject).to receive(:upload_image).with(key: file_path,
                                                     body: file_data)

      subject.run_processor
    end

    it 'removes the file locally' do
      subject.run_processor

      expect(DatabaseImage.find_by(id: database_images_ids[0])).to be_nil
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
