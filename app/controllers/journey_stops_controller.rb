# frozen_string_literal: true

# CRUD For Journey Stop
class JourneyStopsController < ApplicationController
  include PermittedParameters

  PERMITTED_PARAMETERS = %i[
    description
    journey_id
    lat
    long
    title
    place_id
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

      redirect_to journey_path(@journey_stop.journey)
    else
      render_alert_message

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
    return if logged_in_user_created_journey?

    @journey_stop.increment!(:views_count)
  end
  # rubocop:enable Rails/SkipsModelValidations

  def logged_in_user_created_journey?
    current_user == @journey_stop.user
  end

  def post_create_actions
    enqueue_process_images_job
    unlink_tempfiles
    notify_users
  end

  def authorize_journey_stop(method)
    authorize! method, @journey_stop
  end

  def enqueue_process_images_job
    ImagesProcessors::Validator.new(
      imageable_id: @journey_stop.id,
      imageable_type: @journey_stop.class.name,
      http_uploaded_files: params[:journey_stop][:images]
    ).run
  end

  def unlink_tempfiles
    params[:journey_stop][:images].each do |http_file|
      http_file.tempfile.unlink
    end
  end

  def notify_users
    journey = @journey_stop.journey

    NotifierJobs::NewJourneyStop.perform_async(journey.id, @journey_stop.id, journey.user_id)
  end
end
