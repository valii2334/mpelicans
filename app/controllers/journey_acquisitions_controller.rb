# frozen_string_literal: true

# Buy Journey
class JourneyAcquisitionsController < ApplicationController
  before_action :authenticate_user!

  def checkout_session_redirect
    journey_id = stripe_checkout_session.metadata.journey_id
    user_id = stripe_checkout_session.metadata.user_id

    authorize! :buy, Journey.find(journey_id)

    PaidJourney.find_or_create_by!(
      user_id:,
      journey_id:
    )

    redirect_to journey_path(id: journey_id)
  end

  private

  def stripe_checkout_session
    @stripe_checkout_session ||= Stripe::Checkout::Session.retrieve(
      params[:session_id]
    )
  end
end