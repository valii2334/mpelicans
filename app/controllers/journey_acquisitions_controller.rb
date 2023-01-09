# frozen_string_literal: true

# Buy Journey
class JourneyAcquisitionsController < ApplicationController
  before_action :authenticate_user!

  def create
    journey_id = params.require(:journey_id)
    journey = Journey.find(journey_id)

    authorize! :buy, journey

    PaidJourney.find_or_create_by!(
      user_id: current_user.id,
      journey_id:
    )

    redirect_to journey_path(journey)
  end
end
