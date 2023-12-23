# frozen_string_literal: true

# User model
class User < ApplicationRecord
  paginates_per 50

  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  has_one_attached :image do |attachable|
    attachable.variant :max,
                       resize_to_fill: [200, 200],
                       format: :webp,
                       quality: 80
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

  has_many :map_pins, dependent: :destroy

  has_many :pinned_journey_stops,
           through: :map_pins,
           source: :journey_stop

  validates :username, presence: true
  validates :username, uniqueness: { case_sensitive: false }

  validate :username_validator

  default_scope { order(created_at: :desc) }

  attr_writer :login

  def bought_journey?(journey:)
    bought_journeys.include?(journey)
  end

  def follows?(followee:)
    followees.include?(followee)
  end

  def login
    @login || username || email
  end

  def pinned_journey_stop?(journey_stop:)
    pinned_journey_stops.include?(journey_stop)
  end

  # rubocop:disable Metrics/MethodLength
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h)
        .where(
          [
            'lower(username) = :value OR lower(email) = :value',
            { value: login.downcase }
          ]
        ).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def username_validator
    return if username.blank?
    return unless username.match?(/[^a-zA-Z0-9]/)

    errors.add :username, :invalid, message: 'can not contain special characters'
  end
end
