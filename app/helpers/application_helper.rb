# frozen_string_literal: true

# Methods used by views, global
module ApplicationHelper
  AVAILABLE_CONTROLLERS = %w[company journey_stops journeys pelicans].freeze
  AVAILABLE_METHODS     = %w[company_title journey_stops_title journeys_title pelicans_title].freeze

  def page_title
    specific_page_title_method = AVAILABLE_METHODS.find { |method| method == "#{params[:controller]}_title" }

    if AVAILABLE_CONTROLLERS.include?(params[:controller]) && respond_to?(specific_page_title_method)
      send(specific_page_title_method)
    else
      title
    end
  end

  def title
    'MPelicans - Plan your next journey'
  end

  def active_controller_action?(controller:, action:)
    return 'active' if controller_action?(controller:, action:)
  end

  def active_controller?(controller:)
    return 'active' if controller?(controller:)
  end

  def which_journeys_button_class(which_journeys:)
    return select_journeys_tab if params[:which_journeys] == which_journeys

    not_selected_journeys_tab
  end

  def flash_message
    flash[:message] || alert || notice
  end

  def flash_message_type
    return flash[:message_type] if flash[:message_type]
    return 'success'            if notice
    return 'danger'             if alert

    'secondary'
  end

  def mobile_browser?
    Browser.new(request.user_agent).device.mobile?
  end

  def loading_spinner
    "background-image: url(#{asset_url 'gifs/spinner.gif'}); background-repeat: no-repeat; background-position: center;"
  end

  private

  def select_journeys_tab
    'btn-primary'
  end

  def not_selected_journeys_tab
    'btn-outline-primary'
  end

  def can_edit_current_journey?
    can?(:edit, current_journey)
  end

  def bought_current_journey?
    current_user.bought_journey?(journey: current_journey)
  end

  def controller_action?(controller:, action:)
    controller?(controller:) && action?(action:)
  end

  def controller?(controller:)
    params[:controller] == controller
  end

  def action?(action:)
    params[:action] == action
  end

  def current_journey
    if controller?(controller: 'journeys')
      Journey.find_by(id: params[:id])
    elsif controller?(controller: 'journey_stops')
      Journey.find_by(id: params[:journey_id])
    end
  end

  def content_style
    return 'padding-top: 10px;' if params[:controller].include?('devise')
  end
end
