# frozen_string_literal: true

class MapPin < ApplicationRecord
  belongs_to :journey_stop, optional: true
  belongs_to :user

  validates :lat, :long, presence: true
end
