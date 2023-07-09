# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesProcessors::Saver do
  let(:imageable_id)                  { SecureRandom.uuid }
  let(:imageable_type)                { SecureRandom.uuid }
  let(:predefined_secure_random_uuid) { SecureRandom.uuid }
  let(:image_file)                    { Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg') }
  let(:http_uploaded_files)           { [image_file] }
  let(:expected_saved_file_paths)     { [Rails.root.join("tmp/#{predefined_secure_random_uuid}.jpg").to_s] }

  subject { described_class.new(imageable_id:, imageable_type:, http_uploaded_files:) }

  before do
    allow(JourneyJobs::UploadImages).to receive(:perform_async).with(imageable_id, imageable_type,
                                                                     expected_saved_file_paths)
    allow(SecureRandom).to receive(:uuid).and_return(predefined_secure_random_uuid)
  end

  context '#run_processor' do
    it 'returns saved paths' do
      expect(subject.run_processor).to match_array(expected_saved_file_paths)
    end

    it 'saves files locally' do
      subject.run_processor

      expect(File.exist?(expected_saved_file_paths[0])).to be_truthy
    end
  end

  context '#enque_next_steps' do
    it 'calls JourneyJobs::UploadImages.perform_async with desired arguments' do
      expect(JourneyJobs::UploadImages).to receive(:perform_async).with(imageable_id, imageable_type,
                                                                        expected_saved_file_paths)

      subject.run
    end
  end
end
