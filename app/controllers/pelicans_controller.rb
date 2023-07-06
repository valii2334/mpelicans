# frozen_string_literal: true

# User controller
class PelicansController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :set_user, only: %i[edit update]

  def index
    @users = Retrievers::User.new(query_string: params.dig(:pelicans, :query_string)).fetch
    @users = @users.page params[:page]
  end

  def show
    @user = User.find_by!(username: params[:username])

    @journeys = if current_user == @user
                  Retrievers::Journey.new(user: current_user, which_journeys: 'mine').fetch
                else
                  Retrievers::Journey.new(user: @user, which_journeys: 'users').fetch
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
