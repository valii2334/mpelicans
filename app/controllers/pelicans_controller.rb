# frozen_string_literal: true

# User controller
class PelicansController < ApplicationController
  include ActiveRecord::Sanitization

  def index
    @users = if params[:pelicans] && params[:pelicans][:query_string]
               User.where('username ILIKE ?', "%#{params[:pelicans][:query_string]}%")
             else
               []
             end
  end

  def show
    @user = User.find_by!(username: params[:username])
    @journeys = @user.journeys.where(access_type: %i[public_journey monetized_journey])
  end
end
