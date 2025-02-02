# frozen_string_literal: true

# JourneyStop Model
class JourneyStop < ApplicationRecord
  include Rails.application.routes.url_helpers
  include Imageable

  MAXIMUM_NUMBER_OF_IMAGES = 5

  belongs_to :journey
  has_many :notifications, dependent: :destroy
  has_many :uploaded_images, as: :imageable, dependent: :destroy
  has_many :map_pins, dependent: :nullify
  has_rich_text :description

  validates :title, :lat, :long, presence: true
  validate :images_are_present
  validate :maximum_number_of_images

  delegate :user, to: :journey

  default_scope { order(created_at: :desc) }

  before_create :set_latest_journey_stop_added_at

  def meta_description_content
    [title, description.to_plain_text]
  end

  def pin
    Pin.new(pinnable: self).to_pin
  end

  def pins
    [pin]
  end

  def link_to_self
    journey_url(journey, scroll_to: anchor_id, host: ENV.fetch('DEFAULT_HOST'))
  end

  def all_mini_thumbnails
    images_urls(variant: :mini_thumbnail)
  end

  def all_thumbnails
    images_urls(variant: :thumbnail)
  end

  def all_mobiles
    images_urls(variant: :mobile)
  end

  def all_maxs
    images_urls(variant: :max)
  end

  def simple_class_name
    'Stop'
  end

  def anchor_id
    "journey-stop-id-#{id}"
  end

  def link_to_google_maps
    return journey_stop_place_url if place_id.present?

    journey_stop_coordinates_url
  end

  def belongs_to_a_place?
    place_id.present?
  end

  def journey_stop_place_url
    "https://www.google.com/maps/search/?api=1&query=Google&query_place_id=#{place_id}"
  end

  def journey_stop_coordinates_url
    "https://www.google.com/maps/search/?api=1&query=#{lat},#{long}"
  end

  private

  # rubocop:disable Rails/SkipsModelValidations
  def set_latest_journey_stop_added_at
    journey.update_attribute(:latest_journey_stop_added_at, DateTime.now)
  end
  # rubocop:enable Rails/SkipsModelValidations

  def maximum_number_of_images
    return if passed_images_count <= MAXIMUM_NUMBER_OF_IMAGES

    errors.add :images, :invalid, message: "can't post more than #{MAXIMUM_NUMBER_OF_IMAGES}"
  end
end
