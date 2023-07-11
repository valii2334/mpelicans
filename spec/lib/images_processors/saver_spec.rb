# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesProcessors::Saver do
  let(:imageable_id)                  { SecureRandom.uuid }
  let(:imageable_type)                { SecureRandom.uuid }
  let(:image_file)                    { Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg') }
  let(:http_uploaded_files)           { [image_file] }

  subject { described_class.new(imageable_id:, imageable_type:, http_uploaded_files:) }

  before do
    allow(JourneyJobs::UploadImages).to receive(:perform_async).with(imageable_id, imageable_type,
                                                                     instance_of(Array))
  end

  context '#run_processor' do
    it 'saves files in the database', :aggregate_failures do
      database_images_ids = subject.run_processor

      database_image = DatabaseImage.find(database_images_ids[0])

      expect(database_image.data).to be_present
      expect(database_image.file_extension).to eq(File.extname('spec/fixtures/files/lasvegas.jpg'))
    end
  end

  context '#enque_next_steps' do
    it 'calls JourneyJobs::UploadImages.perform_async with desired arguments' do
      expect(JourneyJobs::UploadImages).to receive(:perform_async).with(imageable_id, imageable_type,
                                                                        instance_of(Array))

      subject.run
    end
  end
end
