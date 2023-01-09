# frozen_string_literal: true

# Journey Model
class Journey < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [400, 400]
    attachable.variant :max,   resize_to_limit: [1024, 1024]
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

  def map_url
    if journey_stops.count.zero?
      return 'https://www.google.com/maps/embed/v1/place' \
             "?key=#{ENV.fetch('GOOGLE_MAPS_API_KEY', nil)}&q=#{origin}"
    end

    if journey_stops.count <= 1
      return 'https://www.google.com/maps/embed/v1/directions' \
             "?key=#{ENV.fetch('GOOGLE_MAPS_API_KEY', nil)}&origin=#{origin}&destination=#{destination}"
    end

    'https://www.google.com/maps/embed/v1/directions' \
      "?key=#{ENV.fetch('GOOGLE_MAPS_API_KEY', nil)}&origin=#{origin}&destination=#{destination}&waypoints=#{waypoints}"
  end

  private

  def image_is_present
    errors.add :image, :invalid, message: "can't be blank" if image.blank?
  end

  def origin
    CGI.escape(start_plus_code)
  end

  def destination
    CGI.escape(journey_stops.last.plus_code)
  end

  def waypoints
    plus_codes = journey_stops.pluck(:plus_code)[0...-1].map { |plus_code| CGI.escape(plus_code) }
    plus_codes.join('|')
  end

  def add_access_code
    return if access_code

    self.access_code = SecureRandom.uuid
  end
end
