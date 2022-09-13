module ApplicationHelper
  def active_journey?(journey)
    return 'active' if params[:controller] == 'journeys' && params[:action] == 'show' && params[:id] == journey.id.to_s
    return 'active' if params[:controller] == 'journey_stops' && params[:action] == 'new' && params[:journey_id] == String(journey.id)
  end

  def active_new_journey?
    return 'active' if params[:controller] == 'journeys' && params[:action] == 'new'
  end
end
