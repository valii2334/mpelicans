# frozen_string_literal: true

# JourneyStop Model
class JourneyStop < ApplicationRecord
  belongs_to :journey

  has_many_attached :images do |attachable|
    attachable.variant :max, resize_to_limit: [400, 400]
  end

  validates :description, :title, :plus_code, presence: true

  validate :images_are_present

  default_scope { order(created_at: :asc) }

  def location_link
    "https://www.plus.codes/#{plus_code}"
  end

  def map_url
    MapUrl.new(origin: plus_code).map_url
  end

  private

  def images_are_present
    errors.add :images, :invalid, message: "can't be blank" if images.blank?
  end
end
