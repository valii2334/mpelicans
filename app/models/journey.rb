class Journey < ApplicationRecord
  has_one_attached :image

  belongs_to :user
  has_many :stops

  enum status:      [:not_started, :in_progress, :finished]
  enum access_type: [:private_journey, :protected_journey]

  validates :title, :description, :start_plus_code, presence: true

  before_create :add_access_code

  def map_url
    "https://www.google.com/maps/embed/v1/place?key=#{ENV['GOOGLE_MAPS_API_KEY']}&q=#{CGI.escape(start_plus_code)}"
  end

  private

  def add_access_code
    self.access_code = SecureRandom.hex(5)
  end
end
