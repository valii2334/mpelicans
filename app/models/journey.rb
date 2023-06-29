# frozen_string_literal: true

# Journey Model
class Journey < ApplicationRecord
  include PlusCodeSetterConcern
  include Imageable

  paginates_per 50

  belongs_to :user
  has_many :journey_stops, dependent: :destroy
  has_many :paid_journeys, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :paying_users, through: :paid_journeys, source: :user
  has_many :uploaded_images, as: :imageable, dependent: :destroy

  validates :access_code,
            :description,
            :start_plus_code,
            :title,
            presence: true
  validate :images_are_present

  before_validation :add_access_code

  default_scope { order(updated_at: :desc) }

  alias_attribute :plus_code, :start_plus_code

  enum access_type: {
    private_journey: 0,
    protected_journey: 1,
    public_journey: 2,
    monetized_journey: 3
  }

  def map_url
    MapUrl.new(origin:, destination:, waypoints:).map_url
  end

  private

  def origin
    start_plus_code
  end

  def destination
    return nil if journey_stops.empty?

    journey_stops.last.plus_code
  end

  def waypoints
    return [] if journey_stops.count < 2

    journey_stops.pluck(:plus_code)[0...-1]
  end

  def add_access_code
    return if access_code

    self.access_code = SecureRandom.uuid
  end
end
