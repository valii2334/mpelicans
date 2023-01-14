# frozen_string_literal: true

# Methods used by views, global
module ApplicationHelper
  def active_journey?(journey)
    return 'active' if action_controller?('journeys', 'show') && on_this_journey_page?(journey)

    unless (
      action_controller?('journey_stops', 'new') ||
      action_controller?('journey_stops', 'show')
    ) && journey_stop_belongs_to_journey?(journey)
      return
    end

    'active'
  end

  def active_action_controller?(controller:, action:)
    return 'active' if action_controller?(controller, action)
  end

  private

  def action_controller?(controller, action)
    params[:controller] == controller && params[:action] == action
  end

  def on_this_journey_page?(journey)
    params[:id] == String(journey.id)
  end

  def journey_stop_belongs_to_journey?(journey)
    params[:journey_id] == String(journey.id)
  end

  def journey_privacy_buttons(journey)
    remaining_privacy_types(journey).map do |remaining_privacy_type|
      journey_privacy_button(journey, remaining_privacy_type)
    end
  end

  def journey_privacy_button(journey, privacy_type)
    link_to "Make your journey #{privacy_type}",
            journey_path(
              journey,
              journey: {
                access_type: "#{privacy_type}_journey"
              }
            ),
            method: :put,
            confirm: 'Are you sure?',
            class: 'btn btn-sm btn-outline-primary'
  end

  def remaining_privacy_types(journey)
    if journey.private_journey?
      %w[protected public monetized]
    elsif journey.protected_journey?
      %w[private public monetized]
    elsif journey.public_journey?
      %w[private protected monetized]
    else
      %w[private protected public]
    end
  end
end
