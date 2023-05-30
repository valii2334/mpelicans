# frozen_string_literal: true

# CRUD For Journey
class JourneysController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def index
    @journeys = current_user.journeys
    @bought_journeys = current_user.bought_journeys
  end

  def new
    @journey = Journey.new
  end

  def show
    @journey = Journey.find(params[:id])

    authorize_journey(:show)
  end

  def create
    @journey = Journey.new(journey_params.merge(user_id: current_user.id))

    authorize_journey(:create)

    if @journey.save
      notify_users
      success_message(message: 'Your journey was created.')

      redirect_to journey_path(@journey)
    else
      alert_message

      render action: 'new'
    end
  end

  def update
    @journey = Journey.find(params[:id])

    authorize_journey(:update)

    if @journey.update(journey_update_params)
      success_message(message: 'Your journey was updated.')
    else
      alert_message
    end

    redirect_to journey_path(@journey)
  end

  def destroy
    @journey = Journey.find(params[:id])

    authorize_journey(:destroy)

    if @journey.destroy
      success_message(message: 'Your journey was deleted.')

      redirect_to root_path
    else
      alert_message

      redirect_to journey_path(@journey)
    end
  end

  private

  def notify_users
    NotifierJob.perform_async(@journey.id, 'new_journey', @journey.user_id)
  end

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
      :lat,
      :long,
      :start_plus_code,
      :title
    )
  end

  def authorize_journey(method)
    authorize! method, @journey
  end
end
