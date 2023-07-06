# frozen_string_literal: true

# Relationship controller
class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    followee = User.find(params[:followee_id])

    authorize! :create, Relationship.new, current_user, followee

    Relationship.create!(follower_id: current_user.id, followee_id: params[:followee_id])

    success_message(message: "You are now following #{followee.username} across the world!")

    redirect_to pelican_path(followee.username)
  end

  def destroy
    relationship = Relationship.find(params[:id])
    followee = relationship.followee

    authorize! :destroy, relationship

    if relationship.destroy
      success_message(message: "You are no longer following #{followee.username}.")
    else
      alert_message
    end

    redirect_to pelicans_path
  end
end
