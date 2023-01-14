# frozen_string_literal: true

# CRUD For Journey Stop
class JourneyStopsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def new
    @journey_stop = JourneyStop.new(journey_id: params[:journey_id])
  end

  def create
    @journey_stop = JourneyStop.new(journey_stop_params)

    authorize_journey_stop(:create)

    if @journey_stop.save
      redirect_to journey_path(@journey_stop.journey)
    else
      render action: 'new'
    end
  end

  def destroy
    @journey_stop = JourneyStop.find(params[:id])

    authorize_journey_stop(:destroy)

    journey = @journey_stop.journey
    @journey_stop.destroy

    redirect_to journey_path(journey)
  end

  def show
    @journey_stop = JourneyStop.find(params[:id])

    return if params[:access_code] && params[:access_code] == @journey_stop.journey.access_code

    authorize_journey_stop(:show)
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

  def authorize_journey_stop(method)
    authorize! method, @journey_stop
  end
end
