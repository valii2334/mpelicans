# frozen_string_literal: true

# Define CanCan abilities
class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def initialize(user)
    user ||= User.new

    # Journey abilities
    can :new, Journey
    can :show, Journey do |journey|
      journey.public_journey? ||
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
        bought_journey?(user:, journey: journey_stop.journey)
    end
    can :manage, JourneyStop, journey: { user: }

    # TODO: NOT YET IMPLEMENTED
    can :create, Relationship
    can :destroy, Relationship, followee_id: user.id
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
end
