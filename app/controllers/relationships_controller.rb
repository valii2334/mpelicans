# frozen_string_literal: true

# Relationship controller
class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    follower = User.find(params[:follower_id])

    authorize! :create, Relationship.new, current_user, follower

    Relationship.find_or_create_by!(followee_id: current_user.id, follower_id: params[:follower_id])

    success_message(message: "You are now following #{follower.username} across the world!")

    redirect_to pelican_path(follower.username)
  end

  def destroy
    relationship = Relationship.find(params[:id])
    follower = relationship.follower

    authorize! :destroy, relationship

    if relationship.destroy
      success_message(message: "You are no longer following #{follower.username}.")
    else
      alert_message
    end

    redirect_to pelicans_path
  end
end
