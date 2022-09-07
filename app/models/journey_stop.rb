class JourneyStop < ApplicationRecord
  belongs_to :journey

  has_many_attached :images

  validates :title, :description, :plus_code, presence: true
end
