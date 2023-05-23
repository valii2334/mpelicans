# frozen_string_literal: true

user = User.find_by(username: command_options['user_name'])
journey = Journey.find_by(title: command_options['journey_title'])
success_url = Rails
              .application
              .routes
              .url_helpers
              .checkout_session_redirect_journey_acquisitions_url(
                host: 'localhost:3000'
              )
error_url = Rails
            .application
            .routes
            .url_helpers
            .root_url(
              host: 'localhost:3000'
            )

if command_options['stripe_response'] == 'success'
  allow(Stripe::Checkout::Session).to receive(:create).and_return(
    double(
      'Stripe::Checkout::Session',
      url: "#{success_url}?session_id=CHECKOUT_SESSION_ID"
    )
  )
  allow(Stripe::Checkout::Session).to receive(:retrieve).with('CHECKOUT_SESSION_ID').and_return(
    double(
      'Stripe::Checkout::Session2',
      metadata: double(
        'Metadata',
        user_id: user.id,
        journey_id: journey.id
      ),
      payment_status: 'paid'
    )
  )
else
  allow(Stripe::Checkout::Session).to receive(:create).and_return(
    double(
      'Stripe::Checkout::Session',
      url: error_url
    )
  )
end

nil
