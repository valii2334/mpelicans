# frozen_string_literal: true

# User model
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :journeys, dependent: :destroy
  has_many :paid_journeys, dependent: :destroy

  validates :username, presence: true
  validates :username, uniqueness: true
  validate :username_validator

  private

  def username_validator
    return if username.blank?

    errors.add :base, :invalid, message: 'Username can not contain white spaces' if username.include?(' ')
  end
end
