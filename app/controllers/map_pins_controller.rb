# frozen_string_literal: true

# CRUD For Journey
class MapPinsController < ApplicationController
  include PermittedParameters

  before_action :authenticate_user!, only: %i[create]

  PERMITTED_PARAMETERS = %i[
    journey_stop_id
  ].freeze

  def index
    @map_pins = if user_id
                  MapPin.where(user_id:)
                        .includes(:journey_stop)
                else
                  []
                end

    @map_pins.map { |pinnable| Pin.new(pinnable:).to_pin }
  end

  private

  def user_id
    current_user.try(:id) || params[:id]
  end
end
