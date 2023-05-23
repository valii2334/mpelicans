# frozen_string_literal: true

# Buy Journey
class JourneyAcquisitionsController < ApplicationController
  before_action :authenticate_user!

  def checkout_session_redirect
    authorize! :buy, Journey.find(journey_id)

    if user_paid?
      PaidJourney.create(user_id:, journey_id:)
      notify_users(journey_id:, sender_id: user_id)
    end

    redirect_to journey_path(id: journey_id)
  end

  private

  def stripe_checkout_session
    @stripe_checkout_session ||= Stripe::Checkout::Session.retrieve(
      params[:session_id]
    )
  end

  def journey_id
    stripe_checkout_session.metadata.journey_id
  end

  def user_id
    stripe_checkout_session.metadata.user_id
  end

  def user_paid?
    stripe_checkout_session.payment_status == 'paid'
  end

  def notification_type
    'bought_journey'
  end

  def notify_users(journey_id:, sender_id:)
    NotifierJob.perform_async(journey_id, notification_type, sender_id)
  end
end
