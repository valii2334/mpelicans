# frozen_string_literal: true

module PlusCodeSetterConcern
  extend ActiveSupport::Concern

  included do
    before_validation :set_plus_code, if: %i[plus_code_blank? lat_long_provided?]
  end

  delegate :blank?, to: :plus_code, prefix: true

  def set_plus_code
    self.plus_code = PlusCodeRetriever.new(latitude: lat, longitude: long).run
  end

  def lat_long_provided?
    !(lat.blank? && long.blank?)
  end
end
