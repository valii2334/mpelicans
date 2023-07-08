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
      follower &&
        follower != followee &&
        !follower.follows?(followee:)
    end
    can :destroy, Relationship, follower_id: user.id

    can :create, MapPin do |_, current_user, journey_stop|
      current_user &&
        current_user != journey_stop.user &&
        !current_user.pinned_journey_stop?(journey_stop:)
    end
    can :destroy, MapPin, user_id: user.id
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

  def can_view_journey?(journey:, user:, params:)
    journey.public_journey? ||
      can_view_protected_journey?(journey:, params:) ||
      can_view_monetized_journey?(user:, journey:)
  end
end
