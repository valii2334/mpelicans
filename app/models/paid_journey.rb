# frozen_string_literal: true

class PaidJourney < ApplicationRecord
  belongs_to :user
  belongs_to :journey

  validates :journey_id, uniqueness: { scope: :user_id }
end
