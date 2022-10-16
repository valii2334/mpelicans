# frozen_string_literal: true

# Methods used by views, global
module ApplicationHelper
  def active_journey?(journey)
    return 'active' if action_controller?('journeys', 'show') && on_this_journey_page?(journey)
    return unless action_controller?('journey_stops', 'new') && journey_stop_belongs_to_journey?(journey)

    'active'
  end

  def active_new_journey?
    return 'active' if action_controller?('journeys', 'new')
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
end
