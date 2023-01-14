# frozen_string_literal: true

# JourneyStop Model
class JourneyStop < ApplicationRecord
  belongs_to :journey

  has_many_attached :images do |attachable|
    attachable.variant :max, resize_to_limit: [1024, 1024]
  end

  validates :description, :title, :plus_code, presence: true

  validate :images_are_present

  default_scope { order(created_at: :asc) }

  def location_link
    "https://www.plus.codes/#{plus_code}"
  end

  def map_url
    'https://www.google.com/maps/embed/v1/place' \
      "?key=#{ENV.fetch('GOOGLE_MAPS_API_KEY', nil)}&q=#{plus_code}"
  end

  private

  def images_are_present
    errors.add :images, :invalid, message: "can't be blank" if images.blank?
  end
end
