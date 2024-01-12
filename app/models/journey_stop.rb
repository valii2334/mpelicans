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
    [journey.meta_description_content, title, description.to_plain_text].join('.')
  end

  def pin
    Pin.new(pinnable: self).to_pin
  end

  def pins
    [pin]
  end

  def link_to_self
    journey_url(journey, scroll_to: anchor_id, host: 'https://www.mpelicans.com')
  end

  def all_mini_thumbnails
    images_urls(variant: :mini_thumbnail)
  end

  def all_thumbnails
    images_urls(variant: :thumbnail)
  end

  def all_maxs
    images_urls(variant: :max)
  end

  def simple_class_name
    'Stop'
  end

  def modal_id
    "journey-stop-#{id}"
  end

  def anchor_id
    "journey-stop-id-#{id}"
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
