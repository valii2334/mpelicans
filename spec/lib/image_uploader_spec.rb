# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageUploader do
  let(:journey_stop)   { create :journey_stop }
  let(:image_file)     { Rack::Test::UploadedFile.new('spec/fixtures/files/lasvegas.jpg', 'image/jpeg') }
  let(:text_file)      { Rack::Test::UploadedFile.new('spec/fixtures/files/text.txt', 'text/txt') }
  let(:random_uuid)    { '200fdb12-7b81-4fb0-9b3e-740c7b0578ee' }
  let(:uploaded_files) { [image_file, text_file] }
  let(:expected_key)   { "JourneyStop-#{journey_stop.id}-#{random_uuid}#{File.extname(image_file.tempfile)}" }

  subject { described_class.new(imageable: journey_stop, uploaded_files:).run }

  before do
    allow(SecureRandom).to receive(:uuid).and_return(random_uuid)
    allow(Storage).to receive(:upload).with(key: expected_key, body: instance_of(String)).and_return(true)
  end

  describe 'run' do
    it 'creates one UploadedImage' do
      expect { subject }.to change { journey_stop.uploaded_images.count }.by(1)
    end

    it 'UploadedImage has the correct s3 key' do
      subject

      expect(journey_stop.reload.uploaded_images.last.s3_key).to eq expected_key
    end
  end
end
