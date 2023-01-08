class PelicansController < ApplicationController
  def show
    @user = User.find_by!(username: params[:username])
    @journeys = @user.journeys.where.not(access_type: :private_journey)
  end
end
