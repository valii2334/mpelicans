# frozen_string_literal: true

# Define CanCan abilities
class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def initialize(user, params)
    user ||= User.new

    # Journey abilities
    can :new, Journey
    can :show, Journey do |journey|
      journey.public_journey? ||
        can_view_protected_journey?(journey:, params:) ||
        bought_journey?(user:, journey:)
    end
    can :buy, Journey do |journey|
      boughtable_journey?(user:, journey:)
    end
    can :manage, Journey, user: user

    # Journey Stop abilities
    can :new, JourneyStop
    can :show, JourneyStop do |journey_stop|
      journey_stop.journey.public_journey? ||
        can_view_protected_journey?(journey: journey_stop.journey, params:) ||
        bought_journey?(user:, journey: journey_stop.journey)
    end
    can :manage, JourneyStop, journey: { user: }

    can :create, Relationship do |_, follower, followee|
      !same_user?(followee:, follower:) && !follows?(follower:, followee:)
    end
    can :destroy, Relationship, follower_id: user.id
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def bought_journey?(user:, journey:)
    journey.monetized_journey? &&
      PaidJourney.find_by(user_id: user.id, journey_id: journey.id).present?
  end

  def boughtable_journey?(user:, journey:)
    journey.monetized_journey? &&
      PaidJourney.find_by(user_id: user.id, journey_id: journey.id).blank?
  end

  def same_user?(follower:, followee:)
    follower == followee
  end

  def follows?(follower:, followee:)
    Relationship.find_by(follower_id: follower.id, followee_id: followee.id)
  end

  def can_view_protected_journey?(journey:, params:)
    journey.protected_journey? && journey.access_code == params[:access_code]
  end
end
