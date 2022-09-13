# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :create, Journey
    can :manage, Journey, user: user

    can :new, JourneyStop
    can :manage, JourneyStop, journey: { user: user }
  end
end
