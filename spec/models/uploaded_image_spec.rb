# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UploadedImage, type: :model do
  let(:uploaded_image) { build(:uploaded_image) }
  subject { uploaded_image }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :s3_key }
  it { should have_attribute :imageable_id }
  it { should have_attribute :imageable_type }

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :s3_key }

  ##################################
  # Associations
  ##################################

  it { should belong_to(:imageable) }
end
