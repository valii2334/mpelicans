# frozen_string_literal: true

class MapPin < ApplicationRecord
  belongs_to :journey_stop, optional: true
  belongs_to :user

  delegate :link_to_self,        to: :journey_stop, allow_nil: true
  delegate :link_to_google_maps, to: :journey_stop, allow_nil: true

  validates :lat, :long, :title, presence: true
  validates :journey_stop_id, uniqueness: { scope: :user_id }
end
