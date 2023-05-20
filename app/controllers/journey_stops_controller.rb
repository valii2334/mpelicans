# frozen_string_literal: true

# CRUD For Journey Stop
class JourneyStopsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :process_images, only: [:create]

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
    notify_users(journey: @journey_stop.journey)
    success_message(message: 'Your journey stop was created.')
  end

  def user_passed_images?
    (params[:journey_stop][:images] || []).any?
  end

  def journey_stop_params
    parameters = params.require(:journey_stop).permit(
      :description,
      :journey_id,
      :plus_code,
      :title,
      images: []
    )
    parameters.merge(passed_images: user_passed_images?)
  end

  def authorize_journey_stop(method)
    authorize! method, @journey_stop
  end

  def process_images
    return if (journey_stop_params[:images] || []).empty?

    journey_stop_params[:images].each do |image|
      next unless image.try(:path)

      image.tempfile = ImageProcessing::MiniMagick.source(image.path).resize_to_limit!(1024, 1024)
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
