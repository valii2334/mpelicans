# frozen_string_literal: true

# Journey Model
class Journey < ApplicationRecord
  include Rails.application.routes.url_helpers
  include Imageable

  MAXIMUM_NUMBER_OF_IMAGES = 5
  AVAILABLE_FILTER_BUTTONS = %w[latest mine bought].freeze

  paginates_per 10

  belongs_to :user
  has_many :journey_stops, dependent: :destroy
  has_many :paid_journeys, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :paying_users, through: :paid_journeys, source: :user
  has_many :uploaded_images, as: :imageable, dependent: :destroy

  has_rich_text :description

  validates :access_code,
            :latest_journey_stop_added_at,
            :title,
            presence: true

  validate :images_are_present
  validate :maximum_number_of_images

  default_scope { order(latest_journey_stop_added_at: :desc) }

  alias_attribute :plus_code, :start_plus_code

  enum access_type: {
    public_journey: 0,
    protected_journey: 1,
    private_journey: 2,
    monetized_journey: 3
  }

  before_validation :add_access_code
  before_validation :set_latest_journey_stop_added_at

  def meta_description_content
    [
      title,
      description.to_plain_text,
      journey_stops.map(&:meta_description_content)
    ]
      .flatten
      .join(' ')
  end

  def pins
    journey_stops.map { |pinnable| Pin.new(pinnable:).to_pin }
  end

  def lastest_journey_stop_id
    journey_stops
      .unscoped
      .order(created_at: :asc)
      .last
      .id
  end

  def simple_class_name
    'Journey'
  end

  def modal_id
    "journey-#{id}"
  end

  def journey_mini_thumbnails
    images_urls(variant: :mini_thumbnail)
  end

  def journey_thumbnails
    images_urls(variant: :thumbnail)
  end

  def journey_mobiles
    images_urls(variant: :mobile)
  end

  def journey_maxs
    images_urls(variant: :max)
  end

  def all_mini_thumbnails
    [
      journey_stops.map(&:all_mini_thumbnails),
      journey_mini_thumbnails
    ].flatten
  end

  def all_thumbnails
    [
      journey_stops.map(&:all_thumbnails),
      journey_thumbnails
    ].flatten
  end

  def all_mobiles
    [
      journey_stops.map(&:all_mobiles),
      journey_mobiles
    ].flatten
  end

  def all_maxs
    [
      journey_stops.map(&:all_maxs),
      journey_maxs
    ].flatten
  end

  private

  def set_latest_journey_stop_added_at
    return if latest_journey_stop_added_at

    self.latest_journey_stop_added_at = DateTime.now
  end

  def add_access_code
    return if access_code

    self.access_code = SecureRandom.uuid
  end

  def maximum_number_of_images
    return if passed_images_count <= MAXIMUM_NUMBER_OF_IMAGES

    errors.add :images, :invalid, message: "can't post more than #{MAXIMUM_NUMBER_OF_IMAGES}"
  end
end
