# frozen_string_literal: true

# Journey Model
class Journey < ApplicationRecord
  include Imageable

  paginates_per 50

  belongs_to :user
  has_many :journey_stops, dependent: :destroy
  has_many :paid_journeys, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :paying_users, through: :paid_journeys, source: :user
  has_many :uploaded_images, as: :imageable, dependent: :destroy

  has_rich_text :description

  validates :access_code,
            :lat,
            :long,
            :title,
            presence: true

  validate :images_are_present

  default_scope { order(updated_at: :desc) }

  alias_attribute :plus_code, :start_plus_code

  enum access_type: {
    private_journey: 0,
    protected_journey: 1,
    public_journey: 2,
    monetized_journey: 3
  }

  before_validation :add_access_code

  private

  def add_access_code
    return if access_code

    self.access_code = SecureRandom.uuid
  end
end
