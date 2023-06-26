# frozen_string_literal: true

class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  validate :different_follower_followee

  private

  def different_follower_followee
    errors.add :base, :invalid, message: 'can not follow yourself' if follower == followee
  end
end
