# frozen_string_literal: true

# CRUD For Journey Stop
class JourneyStopsController < ApplicationController
  include PermittedParameters

  before_action :authenticate_user!, except: [:show]

  PERMITTED_PARAMETERS = %i[
    description
    journey_id
    lat
    long
    title
  ].freeze

  def new
    @journey_stop = JourneyStop.new(journey_id: params[:journey_id])
  end

  def create
    @journey_stop = new_journey_stop

    authorize_journey_stop(:create)

    if @journey_stop.save
      post_create_actions

      success_message(message: 'Your journey stop was created.')

      redirect_to journey_journey_stop_path(@journey_stop.journey, @journey_stop)
    else
      alert_message

      render action: 'new'
    end
  end

  def destroy
    @journey_stop = JourneyStop.find(params[:id])

    authorize_journey_stop(:destroy)

    journey = @journey_stop.journey

    if @journey_stop.destroy
      success_message(message: 'Your journey stop was deleted.')
    else
      alert_message
    end

    redirect_to journey_path(journey)
  end

  def show
    @journey_stop = JourneyStop.find(params[:id])

    authorize_journey_stop(:show)

    increase_views_count
  end

  private

  def new_journey_stop
    JourneyStop.new(
      permitted_parameters(
        model: :journey_stop,
        permitted_parameters: PERMITTED_PARAMETERS
      )
    )
  end

  # rubocop:disable Rails/SkipsModelValidations
  def increase_views_count
    @journey_stop.increment!(:views_count)
  end
  # rubocop:enable Rails/SkipsModelValidations

  def post_create_actions
    enqueue_process_images_job
    notify_users
  end

  def authorize_journey_stop(method)
    authorize! method, @journey_stop
  end

  def enqueue_process_images_job
    ImageUploader.new(imageable: @journey_stop, uploaded_files: params[:journey_stop][:images]).run
  end

  def notify_users
    journey = @journey_stop.journey

    NotifierJob.perform_async(journey.id, 'new_journey_stop', journey.user_id)
  end
end
