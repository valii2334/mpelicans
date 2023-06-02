# frozen_string_literal: true

# Define CanCan abilities
class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def initialize(user, params)
    user ||= User.new

    ##################################
    # Journey
    ##################################

    can :new, Journey
    can :show, Journey do |journey|
      can_view_journey?(journey:, user:, params:)
    end
    can :buy, Journey do |journey|
      can_buy_journey?(journey:, user:)
    end
    can :manage, Journey, user: user

    ##################################
    # JourneyStop
    ##################################

    can :new, JourneyStop
    can :show, JourneyStop do |journey_stop|
      can_view_journey?(journey: journey_stop.journey, user:, params:)
    end
    can :manage, JourneyStop, journey: { user: }

    ##################################
    # Relationship
    ##################################

    can :create, Relationship do |_, follower, followee|
      !same_user?(followee:, follower:) && !follows?(follower:, followee:)
    end
    can :destroy, Relationship, follower_id: user.id
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize

  def can_view_monetized_journey?(journey:, user:)
    journey.monetized_journey? && user.bought_journey?(journey:)
  end

  def can_view_protected_journey?(journey:, params:)
    journey.protected_journey? && journey.access_code == params[:access_code]
  end

  def can_buy_journey?(journey:, user:)
    journey.monetized_journey? && !user.bought_journey?(journey:)
  end

  def same_user?(follower:, followee:)
    follower == followee
  end

  def follows?(follower:, followee:)
    Relationship.find_by(follower_id: follower.id, followee_id: followee.id)
  end

  def can_view_journey?(journey:, user:, params:)
    journey.public_journey? ||
      can_view_protected_journey?(journey:, params:) ||
      can_view_monetized_journey?(user:, journey:)
  end
end
