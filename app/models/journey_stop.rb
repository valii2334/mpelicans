class JourneyStop < ApplicationRecord
  belongs_to :journey

  has_many_attached :images

  validates :title, :description, :plus_code, presence: true

  def location_link
    "https://www.plus.codes/#{plus_code}"
  end
end
