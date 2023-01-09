# frozen_string_literal: true

# CRUD For Journey
class JourneysController < ApplicationController
  before_action :authenticate_user!, except: [:show]
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
    @journey = Journey.new(journey_params.merge(user_id: current_user.id))

    if @journey.save
      redirect_to journey_path(@journey)
    else
      render action: 'new'
    end
  end

  def update
    journey = Journey.find(params[:id])
    journey.update(journey_update_params)

    redirect_to journey_path(journey)
  end

  def destroy
    journey = Journey.find(params[:id])

    if journey.destroy
      redirect_to root_path
    else
      redirect_to journey_path(journey)
    end
  end

  private

  def journey_update_params
    params.require(:journey).permit(
      :access_type
    )
  end

  def journey_params
    params.require(:journey).permit(
      :accepts_recommendations,
      :access_type,
      :description,
      :image,
      :start_plus_code,
      :title
    )
  end
end
