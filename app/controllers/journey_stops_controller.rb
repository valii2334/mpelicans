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
      post_create_actions

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
  end

  private

  def post_create_actions
    enqueue_process_images_job
    notify_users(journey: @journey_stop.journey)
    success_message(message: 'Your journey stop was created.')
  end

  def journey_stop_params
    parameters = params.require(:journey_stop).permit(
      :description, :journey_id, :lat, :long,
      :plus_code, :title
    )
    parameters.merge(
      image_processing_status: :waiting,
      passed_images_count: (params[:journey_stop][:images] || []).size
    )
  end

  def authorize_journey_stop(method)
    authorize! method, @journey_stop
  end

  def enqueue_process_images_job
    ImageUploader.new(imageable: @journey_stop, uploaded_files: params[:journey_stop][:images]).run
    JourneyStopJobs::ProcessImages.perform_async(@journey_stop.id)
  end

  def notify_users(journey:)
    NotifierJob.perform_async(journey.id, 'new_journey_stop', journey.user_id)
  end
end
