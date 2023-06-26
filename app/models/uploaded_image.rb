# frozen_string_literal: true

class UploadedImage < ApplicationRecord
  belongs_to :imageable, polymorphic: true

  validates :s3_key, presence: true
end
