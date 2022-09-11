class JourneyStop < ApplicationRecord
  belongs_to :journey

  has_many_attached :images

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
