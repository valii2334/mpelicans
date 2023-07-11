# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DatabaseImage, type: :model do
  let(:database_image) { build(:database_image) }
  subject { database_image }

  ##################################
  # Attribute existence
  ##################################

  it { should have_attribute :data }
  it { should have_attribute :file_extension }

  ##################################
  # Validations
  ##################################

  it { should validate_presence_of :data }
  it { should validate_presence_of :file_extension }
end
