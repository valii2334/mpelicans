# frozen_string_literal: true

# MapUrl class
class MapUrl
  attr_reader :origin, :destination, :waypoints

  def initialize(origin:, destination: nil, waypoints: [])
    @origin = origin
    @destination = destination
    @waypoints = waypoints
  end

  def map_url
    google_maps_url = base_url
    google_maps_url += destination_param if destination.present?
    google_maps_url += waypoints_param unless waypoints.empty?
    google_maps_url
  end

  private

  def base_url
    if destination.present?
      'https://www.google.com/maps/embed/v1/directions' \
        "?key=#{ENV.fetch('GOOGLE_MAPS_API_KEY', nil)}&origin=#{escape_plus_code(origin)}"
    else
      'https://www.google.com/maps/embed/v1/place' \
        "?key=#{ENV.fetch('GOOGLE_MAPS_API_KEY', nil)}&q=#{escape_plus_code(origin)}"
    end
  end

  def destination_param
    "&destination=#{escape_plus_code(destination)}"
  end

  def waypoints_param
    "&waypoints=#{waypoints.map { |plus_code| escape_plus_code(plus_code) }.join('|')}"
  end

  def escape_plus_code(plus_code)
    CGI.escape(plus_code)
  end
end
