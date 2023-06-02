# frozen_string_literal: true

# User controller
class PelicansController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]

  def index
    @users = if params[:pelicans] && params[:pelicans][:query_string]
               query_string = "%#{ActiveRecord::Base.sanitize_sql_like(params[:pelicans][:query_string])}%"
               User
                 .where('username ILIKE ?', query_string)
                 .where.not(id: [current_user.try(:id)])
             else
               []
             end
  end

  def show
    @user = User.find_by!(username: params[:username])

    @journeys = if @user == current_user
                  @user.journeys
                else
                  @user.public_viewable_journeys
                end
  end

  def edit
    @user = current_user
  end

  def update
    current_user.update(update_params)

    reset_password

    if current_user.errors.blank?
      success_message(message: 'Your user was updated')
    else
      alert_message
    end

    redirect_to edit_pelican_path(current_user.username)
  end

  private

  def reset_password
    return if params[:user][:password].blank? && params[:user][:password_confirmation].blank?

    current_user.reset_password(
      params[:user][:password],
      params[:user][:password_confirmation]
    )
  end

  def update_params
    params.require(:user).permit(
      :biography,
      :image,
      :username
    )
  end
end
