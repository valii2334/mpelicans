# frozen_string_literal: true

# Relationship controller
class RelationshipController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def create
    Relationship.find_or_create_by!(followee_id: current_user.id, follower_id: params[:follower_id])

    redirect_to :back
  end

  def destroy
    relationship = Relationship.find(params[:id])

    authorize! :destroy, relationship

    relationship.destroy

    redirect_to :back
  end
end
