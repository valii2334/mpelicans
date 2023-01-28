# frozen_string_literal: true

# User controller
class PelicansController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]

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

  def edit
    @user = current_user
  end

  def update
    current_user.update(update_params)

    reset_password

    redirect_to edit_pelican_path(current_user.username)
  end

  private

  def reset_password
    current_user.reset_password(
      params[:user][:password],
      params[:user][:password_confirmation]
    )
  end

  def update_params
    params.require(:user).permit(
      :biography,
      :image,
      :username,
      :password,
      :password_confirmation
    )
  end
end
