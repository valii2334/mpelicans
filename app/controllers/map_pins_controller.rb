# frozen_string_literal: true

# CRUD For Journey
class MapPinsController < ApplicationController
  include PermittedParameters

  before_action :authenticate_user!, only: %i[create destroy]

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

    @map_pins = @map_pins.map { |pinnable| Pin.new(pinnable:).to_pin }
  end

  def create
    @journey_stop = JourneyStop.find(params[:journey_stop_id])

    authorize! :create, MapPin.new, current_user, @journey_stop

    MapPin.create!(map_pin_attributes)

    respond_to do |format|
      format.html { head :ok }
      format.js   { render 'actions' }
    end
  end

  def destroy
    map_pin = MapPin.find(params[:id])
    @journey_stop = map_pin.journey_stop

    authorize! :destroy, map_pin

    map_pin.destroy

    respond_to do |format|
      format.html { head :ok }
      format.js   { render 'actions' }
    end
  end

  private

  def map_pin_attributes
    {
      journey_stop_id: @journey_stop.id,
      lat: @journey_stop.lat,
      long: @journey_stop.long,
      user_id: current_user.id
    }
  end

  def user_id
    current_user.try(:id) || params[:id]
  end
end
