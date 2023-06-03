# frozen_string_literal: true

# User model
class User < ApplicationRecord
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :image do |attachable|
    attachable.variant :max, resize_and_pad: [400, 400]
  end

  has_many :journeys, dependent: :destroy

  has_many :paid_journeys,
           class_name: 'PaidJourney',
           dependent: :destroy,
           inverse_of: :user

  has_many :bought_journeys,
           through: :paid_journeys,
           source: :journey

  has_many :followed_users,
           foreign_key: :follower_id,
           class_name: 'Relationship',
           dependent: :destroy,
           inverse_of: :follower

  has_many :followees, through: :followed_users

  has_many :following_users,
           foreign_key: :followee_id,
           class_name: 'Relationship',
           dependent: :destroy,
           inverse_of: :followee

  has_many :followers, through: :following_users

  has_many :received_notifications,
           foreign_key: :receiver_id,
           class_name: 'Notification',
           dependent: :destroy,
           inverse_of: :receiver

  validates :username, presence: true
  validates :username, uniqueness: true
  validate :username_validator

  delegate :public_viewable_journeys, to: :journeys

  def bought_journey?(journey:)
    return unless journey

    PaidJourney.find_by(user_id: id, journey_id: journey.id)
  end

  private

  def username_validator
    return if username.blank?
    return unless username.match?(/[^a-zA-Z0-9]/)

    errors.add :username, :invalid, message: 'can not contain special characters'
  end
end
