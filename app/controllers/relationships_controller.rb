# frozen_string_literal: true

# Relationship controller
class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def create
    Relationship.find_or_create_by!(followee_id: current_user.id, follower_id: params[:follower_id])

    follower = User.find(params[:follower_id])

    success_message(message: "You are now following #{follower.username} across the world!")

    redirect_to :back
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

    redirect_to :back
  end
end
