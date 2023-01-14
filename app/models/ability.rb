# frozen_string_literal: true

# Define CanCan abilities
class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/MethodLength
  def initialize(user)
    user ||= User.new

    can :create, Journey
    can :show, Journey do |journey|
      journey.public_journey? ||
        bought_journey?(user:, journey:)
    end
    can :buy, Journey do |journey|
      boughtable_journey?(user:, journey:)
    end
    can :manage, Journey, user: user

    # TODO: NOT YET TESTED
    can :new, JourneyStop
    can :manage, JourneyStop, journey: { user: }

    # TODO: NOT YET IMPLEMENTED
    can :create, Relationship
    can :destroy, Relationship, followee_id: user.id
  end
  # rubocop:enable Metrics/MethodLength

  def bought_journey?(user:, journey:)
    journey.monetized_journey? &&
      PaidJourney.find_by(user_id: user.id, journey_id: journey.id).present?
  end

  def boughtable_journey?(user:, journey:)
    journey.monetized_journey? &&
      PaidJourney.find_by(user_id: user.id, journey_id: journey.id).blank?
  end
end
