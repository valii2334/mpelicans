# frozen_string_literal: true

class Pin
  attr_reader :pinnable, :title, :link_to_self, :link_to_google_maps, :lat, :lng

  def initialize(pinnable:)
    @pinnable            = pinnable
    @title               = pinnable.title
    @link_to_self        = pinnable.link_to_self
    @link_to_google_maps = pinnable.link_to_google_maps
    @lat                 = pinnable.lat
    @lng                 = pinnable.long
  end

  def to_pin
    {
      title:,
      link_to_self:,
      link_to_google_maps:,
      position: {
        lat:,
        lng:
      }
    }
  end
end
