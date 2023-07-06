# frozen_string_literal: true

class MapPin < ApplicationRecord
  belongs_to :journey_stop, optional: true
  belongs_to :user

  delegate :title, :link_to_self, to: :journey_stop, allow_nil: true

  validates :lat, :long, presence: true
end
