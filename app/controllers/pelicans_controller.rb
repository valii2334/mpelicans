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

    @journeys = if current_user_on_his_profile_page?
                  current_users_journeys
                else
                  another_users_journeys
                end
  end

  def edit; end

  def update
    @user.update(update_params)

    reset_password if can_reset_password?

    if @user.errors.blank?
      render_success_message(message: 'Your user was updated')
    else
      render_alert_message
    end

    render 'edit'
  end

  private

  def current_user_on_his_profile_page?
    current_user == @user
  end

  def current_users_journeys
    Retrievers::Journey.new(user: current_user, which_journeys: 'mine').fetch
  end

  def another_users_journeys
    Retrievers::Journey.new(user: @user, which_journeys: 'users').fetch
  end

  def set_user
    @user = current_user
  end

  def reset_password
    current_user.reset_password(
      password,
      password_confirmation
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

  def can_reset_password?
    password && password_confirmation
  end

  def password
    params[:user][:password]
  end

  def password_confirmation
    params[:user][:password_confirmation]
  end
end
