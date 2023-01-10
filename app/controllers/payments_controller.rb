# frozen_string_literal: true

# Payments controller
class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create_checkout_session
    journey = Journey.find(params[:journey_id])

    authorize! :buy, journey

    session = Stripe::Checkout::Session.create({
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            name: product_name(journey),
          },
          unit_amount: 200,
        },
        quantity: 1,
      }],
      customer_email: current_user.email,
      mode: 'payment',
      success_url: "#{checkout_session_redirect_journey_acquisitions_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: root_url,
      metadata: {
        user_id: current_user.id,
        journey_id: journey.id
      }
    })

    redirect_to session.url, allow_other_host: true
  end

  private

  def product_name(journey)
    "MPelicans journey: #{journey.title}"
  end
end
