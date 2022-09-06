class Journey < ApplicationRecord
  has_one_attached :image

  belongs_to :user

  enum status:      [:not_started, :in_progress, :finished]
  enum access_type: [:private_journey, :protect_journey, :public_journey]

  validates :title, :description, :start_plus_code, presence: true
end
