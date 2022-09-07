# frozen_string_literal: true

class JourneysController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @journeys = current_user.journeys
  end

  def new
    @journey = Journey.new
  end

  def show
    @journey = Journey.find(params[:id])
  end

  def create
    @journey = Journey.create(journey_params.merge(user_id: current_user.id))

    redirect_to journey_path(@journey)
  end

  private

  def journey_params
    params.require(:journey).permit(
      :accepts_recommendations,
      :access_type,
      :description,
      :image,
      :start_plus_code,
      :status,
      :title
    )
  end
end
