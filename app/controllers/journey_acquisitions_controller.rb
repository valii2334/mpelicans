# frozen_string_literal: true

# Buy Journey
class JourneyAcquisitionsController < ApplicationController
  before_action :authenticate_user!

  def checkout_session_redirect
    stripe_checkout_session = Stripe::Checkout::Session.retrieve(
      params[:session_id]
    )

    journey_id = stripe_checkout_session.metadata.journey_id
    user_id = stripe_checkout_session.metadata.user_id
    journey = Journey.find(journey_id)

    authorize! :buy, journey

    PaidJourney.find_or_create_by!(
      user_id: user_id,
      journey_id:
    )

    redirect_to journey_path(journey)
  end
end
