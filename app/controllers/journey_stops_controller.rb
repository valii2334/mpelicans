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
      :description,
      :journey_id,
      :plus_code,
      :title
    )
    parameters.merge(passed_images_count: passed_images.size)
  end

  def authorize_journey_stop(method)
    authorize! method, @journey_stop
  end

  def enqueue_process_images_job
    if Rails.env.test?
      JourneyStopImageProcessor.new(journey_stop_id: @journey_stop.id, images_paths: image_paths).run
    else
      JourneyStopJobs::ProcessImages.perform_async(@journey_stop.id, image_paths)
    end
  end

  def image_paths
    passed_images.map { |image| save_image_to_file(image:) }
  end

  def save_image_to_file(image:)
    file_path = "/tmp/#{File.basename(image.tempfile)}"
    File.binwrite(file_path, image.tempfile.read)
    file_path
  end

  def passed_images
    (params[:journey_stop][:images] || []).select do |image|
      image.is_a?(ActionDispatch::Http::UploadedFile)
    end
  end

  def notify_users(journey:)
    Notifier.new(
      journey_id: journey.id,
      notification_type: :new_journey_stop,
      sender_id: journey.user_id
    ).notify
  end
end
