# frozen_string_literal: true

class JourneyStopsController < ApplicationController
  before_action :authenticate_user!
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

  private

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
