# frozen_string_literal: true

# CRUD For User
class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    current_user.update(update_params)

    redirect_to edit_user_path(current_user)
  end

  private

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
