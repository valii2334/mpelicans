# frozen_string_literal: true

class PlusCodeRetriever
  GOOGLE_REVERSE_GEOCODING_API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='

  attr_accessor :latitude, :longitude

  def initialize(latitude:, longitude:)
    @latitude  = latitude.squish
    @longitude = longitude.squish

    raise ArgumentError if latitude.blank? || longitude.blank?
  end

  def run
    fetch_plus_code
  end

  private

  def fetch_plus_code
    response = Faraday.get(request_url)

    unless response.status == 200
      raise StandardError,
            "Google reverse geocoding API responded with: #{response.status}. " \
            "Latitude: #{latitude}, longitude: #{longitude}"
    end

    extract_global_code(response_body: response.body)
  end

  def request_url
    "#{GOOGLE_REVERSE_GEOCODING_API_URL}#{latitude},#{longitude}&key=#{ENV.fetch('GOOGLE_MAPS_API_KEY', nil)}"
  end

  def extract_global_code(response_body:)
    json_response = JSON.parse(response_body)

    unless json_response['status'] == 'OK'
      raise StandardError,
            "Google reverse geocoding API responded with: #{json_response['status']}"
    end

    json_response['plus_code']['global_code']
  end
end
