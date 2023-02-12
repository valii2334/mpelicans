# frozen_string_literal: true

# Journey Model
class Journey < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :max, resize_to_limit: [1024, 1024]
  end

  belongs_to :user
  has_many :journey_stops, dependent: :destroy
  has_many :paid_journeys, dependent: :destroy

  enum access_type: {
    private_journey: 0,
    protected_journey: 1,
    public_journey: 2,
    monetized_journey: 3
  }

  validates :access_code,
            :description,
            :start_plus_code,
            :title,
            presence: true

  validate :image_is_present

  before_validation :add_access_code

  scope :public_viewable_journeys, -> { where(access_type: %i[public_journey monetized_journey]) }

  def map_url
    MapUrl.new(origin:, destination:, waypoints:).map_url
  end

  private

  def image_is_present
    errors.add :image, :invalid, message: "can't be blank" if image.blank?
  end

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
