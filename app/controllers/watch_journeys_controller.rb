# frozen_string_literal: true

# External users views a journey
class WatchJourneysController < ApplicationController
  def show
    @journey = Journey.find_by(access_code: params[:access_code], access_type: :protected_journey)

    raise ActionController::RoutingError.new('Not Found') unless @journey
  end
end
