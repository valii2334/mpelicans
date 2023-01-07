# frozen_string_literal: true

# CRUD For Journey Stop
class JourneyStopsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_journey, only: %i[new create]
  load_and_authorize_resource

  def new
    @journey_stop = JourneyStop.new
  end

  def create
    @journey_stop = JourneyStop.new(journey_stop_params)

    if @journey_stop.save
      redirect_to journey_path(@journey_stop.journey)
    else
      render action: 'new'
    end
  end

  def destroy
    journey_stop = JourneyStop.find(params[:id])
    journey = journey_stop.journey
    journey_stop.destroy

    redirect_to journey_path(journey)
  end

  private

  def load_journey
    @journey = Journey.find(params[:journey_id])
  end

  def journey_stop_params
    params.require(:journey_stop).permit(
      :description,
      :journey_id,
      :plus_code,
      :title,
      images: []
    )
  end
end
