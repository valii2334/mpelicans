# frozen_string_literal: true

# CRUD For Journey
class JourneysController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def index
    @journeys = current_user.journeys
  end

  def new
    @journey = Journey.new
  end

  def show
    @journey = Journey.find(params[:id])

    authorize_journey(:show)
  end

  def create
    @journey = Journey.new(journey_params)

    authorize_journey(:create)

    if @journey.save
      redirect_to journey_path(@journey)
    else
      render action: 'new'
    end
  end

  def update
    @journey = Journey.find(params[:id])

    authorize_journey(:update)

    @journey.update(journey_update_params)

    redirect_to journey_path(@journey)
  end

  def destroy
    @journey = Journey.find(params[:id])

    authorize_journey(:destroy)

    if @journey.destroy
      redirect_to root_path
    else
      redirect_to journey_path(@journey)
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
      :title,
      :user_id
    )
  end

  def authorize_journey(method)
    authorize! method, @journey
  end
end
