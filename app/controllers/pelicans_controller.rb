class PelicansController < ApplicationController
  def show
    @user = User.find_by!(username: params[:username])
    @journeys = @user.journeys.where(access_type: [:public_journey, :monetized_journey])
  end
end
