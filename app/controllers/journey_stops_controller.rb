# frozen_string_literal: true

require 'async'
require 'async/barrier'

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
    parameters.merge(
      image_processing_status: :waiting,
      passed_images_count: passed_images.size
    )
  end

  def authorize_journey_stop(method)
    authorize! method, @journey_stop
  end

  def enqueue_process_images_job
    upload_images

    if Rails.env.test?
      JourneyStopImageProcessor.new(journey_stop_id: @journey_stop.id, images_paths: image_paths).run
    else
      JourneyStopJobs::ProcessImages.perform_async(@journey_stop.id, image_paths)
    end
  end

  def upload_images
    barrier = Async::Barrier.new

    Async do
      passed_images.each do |passed_image|
        barrier.async { upload_image(image: passed_image) }
      end

      barrier.wait
    end
  end

  def image_paths
    passed_images.map { |image| image_key(image:) }
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

  def upload_image(image:)
    Storage.upload(
      key: image_key(image:),
      body: image.tempfile.read
    )
  end

  def image_key(image:)
    File.basename(image.tempfile)
  end
end
