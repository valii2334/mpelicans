# frozen_string_literal: true

# Journey Model
class Journey < ApplicationRecord
  include Imageable

  MAXIMUM_NUMBER_OF_IMAGES = 5
  AVAILABLE_FILTER_BUTTONS = %w[latest mine bought].freeze

  paginates_per 50

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
    [title, description.to_plain_text].join('.')
  end

  def pins
    journey_stops.map { |pinnable| Pin.new(pinnable:).to_pin }
  end

  def all_thumbnails
    [
      images_urls(variant: :thumbnail),
      journey_stops.map(&:all_thumbnails)
    ].flatten
  end

  def all_maxs
    [
      images_urls(variant: :max),
      journey_stops.map(&:all_maxs)
    ].flatten
  end

  def lastest_journey_stop_id
    journey_stops
      .unscoped
      .order(created_at: :asc)
      .last
      .id
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
