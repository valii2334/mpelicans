# frozen_string_literal: true

class WatchJourneysController < ApplicationController
  def show
    @journey = Journey.find_by(access_code: params[:access_code], access_type: :protected_journey)

    render layout: 'simple'
  end
end
