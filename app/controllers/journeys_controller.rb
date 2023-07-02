# frozen_string_literal: true

# CRUD For Journey
class JourneysController < ApplicationController
  include PermittedParameters

  before_action :authenticate_user!, except: %i[index show]

  PERMITTED_PARAMETERS = %i[
    accepts_recommendations
    access_type
    description
    image
    lat
    long
    title
  ].freeze

  def index
    @journeys = Retrievers::Journey.new(user: current_user, which_journeys: params[:which_journeys]).fetch
    @journeys = @journeys.page params[:page]
  end

  def new
    @journey = Journey.new
  end

  def show
    @journey = Journey.find(params[:id])

    authorize_journey(:show)
  end

  def create
    @journey = new_journey

    authorize_journey(:create)

    if @journey.save
      post_create_actions

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

  def new_journey
    Journey.new(permitted_parameters(
      model: :journey,
      permitted_parameters: PERMITTED_PARAMETERS
    ).merge(user_id: current_user.id))
  end

  def post_create_actions
    enqueue_process_images_job
    notify_users
    success_message(message: 'Your journey was created.')
  end

  def enqueue_process_images_job
    ImageUploader.new(imageable: @journey, uploaded_files: [params[:journey][:images]]).run
    JourneyJobs::ProcessImages.perform_async(@journey.id, 'journey')
  end

  def notify_users
    NotifierJob.perform_async(@journey.id, 'new_journey', @journey.user_id)
  end

  def journey_update_params
    params.require(:journey).permit(
      :access_type
    )
  end

  def authorize_journey(method)
    authorize! method, @journey
  end
end
