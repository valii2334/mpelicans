# frozen_string_literal: true

# User controller
class PelicansController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :set_user, only: %i[edit update]

  def index
    @users = fetch_users
    @users = @users.page params[:page]
  end

  def show
    @user = User.find_by!(username: params[:username])

    @journeys = if @user == current_user
                  @user.journeys
                else
                  @user.public_viewable_journeys
                end
  end

  def edit; end

  def update
    @user.update(update_params)

    reset_password

    if @user.errors.blank?
      render_success_message(message: 'Your user was updated')
    else
      render_alert_message
    end

    render 'edit'
  end

  private

  def fetch_users
    return User.order(created_at: :asc) unless query_string

    User
      .where('username ILIKE ?', query_string)
      .where.not(id: [current_user.try(:id)])
  end

  def query_string
    return nil unless params[:pelicans] && params[:pelicans][:query_string]

    "%#{ActiveRecord::Base.sanitize_sql_like(params[:pelicans][:query_string])}%"
  end

  def set_user
    @user = current_user
  end

  def reset_password
    current_user.reset_password(
      params[:user][:password],
      params[:user][:password_confirmation]
    )

    bypass_sign_in current_user
  end

  def update_params
    params.require(:user).permit(
      :biography,
      :image,
      :username
    )
  end
end
