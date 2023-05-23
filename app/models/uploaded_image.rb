# frozen_string_literal: true

class UploadedImage < ApplicationRecord
  belongs_to :journey_stop

  validates :s3_key, presence: true
end
