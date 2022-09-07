class Journey < ApplicationRecord
  has_one_attached :image

  belongs_to :user

  enum status:      [:not_started, :in_progress, :finished]
  enum access_type: [:private_journey, :protect_journey]

  validates :title, :description, :start_plus_code, presence: true

  def map_url
    "https://www.google.com/maps/embed/v1/place?key=#{ENV['GOOGLE_MAPS_API_KEY']}&q=#{CGI.escape(start_plus_code)}"
  end
end
