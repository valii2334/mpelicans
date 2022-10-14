class JourneyStop < ApplicationRecord
  belongs_to :journey

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [400, 400]
    attachable.variant :max,   resize_to_limit: [1024, 1024]
  end

  validates :title, :description, :plus_code, presence: true

  validate :images_are_present

  def location_link
    "https://www.plus.codes/#{plus_code}"
  end

  private

  def images_are_present
    unless images.present?
      errors.add :images, :invalid, message: "can't be blank"
    end
  end
end
