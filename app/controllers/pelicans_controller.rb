# frozen_string_literal: true

# User controller
class PelicansController < ApplicationController
  def index; end

  def show
    @user = User.find_by!(username: params[:username])
    @journeys = @user.journeys.where(access_type: %i[public_journey monetized_journey])
  end
end
