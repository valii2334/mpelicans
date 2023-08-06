# frozen_string_literal: true

# Relationship controller
class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    authorize! :create, Relationship.new, current_user, followee

    Relationship.create!(follower_id: current_user.id, followee_id: params[:followee_id])
    post_create_actions

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

  private

  def followee
    @followee ||= User.find(params[:followee_id])
  end

  def post_create_actions
    notify_users
    set_flash_message
  end

  def set_flash_message
    success_message(message: "You are now following #{followee.username} across the world!")
  end

  def notify_users
    NotifierJobs::NewFollower.perform_async(current_user.id, params[:followee_id])
  end
end
