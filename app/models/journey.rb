class Journey < ApplicationRecord
  has_one_attached :image

  belongs_to :user
  has_many :journey_stops, dependent: :destroy

  enum status:      [:not_started, :in_progress, :finished]
  enum access_type: [:private_journey, :protected_journey]

  validates :title, :description, :start_plus_code, presence: true

  before_create :add_access_code

  def map_url
    return "https://www.google.com/maps/embed/v1/place?key=#{ENV['GOOGLE_MAPS_API_KEY']}&q=#{origin}" if journey_stops.count.zero?
    return "https://www.google.com/maps/embed/v1/directions?key=#{ENV['GOOGLE_MAPS_API_KEY']}&origin=#{origin}&destination=#{destination}" if journey_stops.count <= 1

    "https://www.google.com/maps/embed/v1/directions?key=#{ENV['GOOGLE_MAPS_API_KEY']}&origin=#{origin}&destination=#{destination}&waypoints=#{waypoints}"
  end

  private

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
    self.access_code = SecureRandom.hex(5)
  end
end
