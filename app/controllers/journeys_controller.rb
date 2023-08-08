# frozen_string_literal: true

# CRUD For Journey
class JourneysController < ApplicationController
  include PermittedParameters

  before_action :authenticate_user!, except: %i[index show]

  PERMITTED_PARAMETERS = %i[
    accepts_recommendations
    access_type
    description
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

    increase_views_count
  end

  def create
    @journey = new_journey

    authorize_journey(:create)

    if @journey.save
      post_create_actions

      success_message(message: 'Your journey was created.')

      redirect_to journey_path(@journey)
    else
      render_alert_message

      render action: 'new'
    end
  end

  def destroy
    @journey = Journey.find(params[:id])

    authorize_journey(:destroy)

    if @journey.destroy
      success_message(message: 'Your journey was deleted.')

      redirect_to root_path
    else
      render_alert_message

      redirect_to journey_path(@journey)
    end
  end

  private

  # rubocop:disable Rails/SkipsModelValidations
  def increase_views_count
    return if current_user == @journey.user

    @journey.increment!(:views_count)
  end
  # rubocop:enable Rails/SkipsModelValidations

  def new_journey
    Journey.new(permitted_parameters(
      model: :journey,
      permitted_parameters: PERMITTED_PARAMETERS
    ).merge(user_id: current_user.id))
  end

  def post_create_actions
    enqueue_process_images_job
    notify_users
  end

  def enqueue_process_images_job
    ImagesProcessors::Validator.new(
      imageable_id: @journey.id,
      imageable_type: @journey.class.name,
      http_uploaded_files: params[:journey][:images]
    ).run
  end

  def notify_users
    NotifierJobs::NewJourney.perform_async(@journey.id, @journey.user_id)
  end

  def authorize_journey(method)
    authorize! method, @journey
  end
end
