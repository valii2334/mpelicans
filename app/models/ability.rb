# frozen_string_literal: true

# Define CanCan abilities
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :create, Journey
    can :show, Journey, access_type: [:public_journey, :monetized_journey]
    can :manage, Journey, user: user

    can :new, JourneyStop
    can :manage, JourneyStop, journey: { user: }
  end
end
