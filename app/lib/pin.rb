# frozen_string_literal: true

class Pin
  attr_accessor :pinnable

  def initialize(pinnable:)
    @pinnable = pinnable
  end

  def to_pin
    {
      title: pinnable.title,
      link_to_self: pinnable.link_to_self,
      link_to_google_maps:,
      position: {
        lat: pinnable.lat,
        lng: pinnable.long
      }
    }
  end

  private

  def link_to_google_maps
    if pinnable.place_id.present?
      return "https://www.google.com/maps/search/?api=1&query=Google&query_place_id=#{pinnable.place_id}"
    end

    "https://www.google.com/maps/search/?api=1&query=#{pinnable.lat},#{pinnable.long}"
  end
end
