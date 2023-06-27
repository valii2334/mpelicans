# frozen_string_literal: true

# JourneyStop Model
class JourneyStop < ApplicationRecord
  include PlusCodeSetterConcern
  include Imageable

  MAXIMUM_NUMBER_OF_IMAGES = 5

  belongs_to :journey
  has_many :notifications, dependent: :destroy
  has_many :uploaded_images, as: :imageable, dependent: :destroy

  validates :description, :title, :plus_code, presence: true
  validate :images_are_present
  validate :maximum_number_of_images

  default_scope { order(created_at: :desc) }

  def location_link
    "https://www.plus.codes/#{plus_code}"
  end

  def map_url
    MapUrl.new(origin: plus_code).map_url
  end

  def maximum_number_of_images
    return if passed_images_count <= MAXIMUM_NUMBER_OF_IMAGES

    errors.add :images, :invalid, message: "can't post more than #{MAXIMUM_NUMBER_OF_IMAGES} images"
  end
end
