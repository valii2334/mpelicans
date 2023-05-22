# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Storage do
  let(:aws_client) { double('Aws::S3::Client') }
  let(:s3_bucket_name) { 'bucket' }

  let(:key) { double('key') }
  let(:body) { double('body') }

  before do
    allow(Storage).to receive(:client).and_return(aws_client)
    allow(ENV).to receive(:fetch).with('S3_BUCKET', nil).and_return(s3_bucket_name)
  end

  describe '#upload' do
    let(:put_parameters) do
      {
        bucket: s3_bucket_name,
        acl: 'private',
        body:,
        key:
      }
    end

    subject { described_class.upload(key:, body:) }

    before do
      allow(aws_client).to receive(:put_object).with(put_parameters)
    end

    it 'calls put_object' do
      expect(aws_client).to receive(:put_object).with(put_parameters)

      subject
    end
  end

  describe '#download' do
    let(:get_parameters) do
      {
        bucket: s3_bucket_name,
        key:
      }
    end

    subject { described_class.download(key:) }

    before do
      allow(aws_client).to receive(:get_object).with(get_parameters)
    end

    it 'calls put_object' do
      expect(aws_client).to receive(:get_object).with(get_parameters)

      subject
    end
  end

  describe '#delete' do
    let(:delete_parameters) do
      {
        bucket: s3_bucket_name,
        key:
      }
    end

    subject { described_class.delete(key:) }

    before do
      allow(aws_client).to receive(:delete_object).with(delete_parameters)
    end

    it 'calls put_object' do
      expect(aws_client).to receive(:delete_object).with(delete_parameters)

      subject
    end
  end
end
