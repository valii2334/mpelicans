# frozen_string_literal: true

# User model
class User < ApplicationRecord
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :journeys, dependent: :destroy
  has_many :paid_journeys, dependent: :destroy

  has_many :followed_users, foreign_key: :follower_id, class_name: 'Relationship'
  has_many :followees, through: :followed_users, dependent: :delete_all

  has_many :following_users, foreign_key: :followee_id, class_name: 'Relationship'
  has_many :followers, through: :following_users, dependent: :delete_all

  validates :username, presence: true
  validates :username, uniqueness: true
  validate :username_validator

  private

  def username_validator
    return if username.blank?

    errors.add :base, :invalid, message: 'Username can not contain white spaces' if username.include?(' ')
  end
end
