# frozen_string_literal: true

# JourneyStop Model
class JourneyStop < ApplicationRecord
  MAXIMUM_NUMBER_OF_IMAGES = 5

  belongs_to :journey

  has_many_attached :images do |attachable|
    attachable.variant :max, resize_to_limit: [400, 400]
  end

  validates :description, :title, :plus_code, presence: true

  validate :images_are_present
  validate :maximum_number_of_images

  default_scope { order(created_at: :asc) }

  enum image_processing_status: {
    waiting: 0,
    processing: 1,
    processed: 2
  }

  def location_link
    "https://www.plus.codes/#{plus_code}"
  end

  def map_url
    MapUrl.new(origin: plus_code).map_url
  end

  private

  def images_are_present
    errors.add :images, :invalid, message: "can't be blank" if passed_images_count.zero?
  end

  def maximum_number_of_images
    return if passed_images_count <= MAXIMUM_NUMBER_OF_IMAGES

    errors.add :images, :invalid, message: "can't post more than #{MAXIMUM_NUMBER_OF_IMAGES} images"
  end
end
