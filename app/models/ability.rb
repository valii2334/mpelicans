# frozen_string_literal: true

# Define CanCan abilities
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :create, Journey
    # Public journeys can be seen by everybody
    can :show, Journey, access_type: %i[public_journey]
    # If a journey is monetized and we bought it we can see it
    can :show, Journey do |journey|
      journey.monetized_journey? &&
        PaidJourney.find_by(user_id: user.id, journey_id: journey.id).present?
    end
    # If a journey is monetized but we haven't bought it yet we can buy it
    can :buy, Journey do |journey|
      journey.monetized_journey? &&
        PaidJourney.find_by(user_id: user.id, journey_id: journey.id).blank?
    end
    can :manage, Journey, user: user

    can :new, JourneyStop
    can :manage, JourneyStop, journey: { user: }

    can :create, Relationship
    can :destroy, Relationship, followee_id: user.id
  end
end
