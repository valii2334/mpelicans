# frozen_string_literal: true

# Define CanCan abilities
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :create, Journey

    can :show, Journey, access_type: %i[public_journey]
    can :show, Journey do |journey|
      PaidJourney.find_by(user_id: user.id, journey_id: journey.id).present?
    end
    can :manage, Journey, user: user

    can :new, JourneyStop
    can :manage, JourneyStop, journey: { user: }
  end
end
