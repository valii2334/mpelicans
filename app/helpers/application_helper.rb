module ApplicationHelper
  def active_journey?(journey)
    return 'active' if params[:controller] == 'journeys' && params[:action] == 'show' && params[:id] == journey.id.to_s
  end

  def active_new_journey?
    return 'active' if params[:controller] == 'journeys' && params[:action] == 'new'
  end
end
