# frozen_string_literal: true

# Methods used by views, global
module ApplicationHelper
  def active_controller_action?(controller:, action:)
    return 'active' if controller_action?(controller:, action:)
  end

  def active_controller?(controller:)
    return 'active' if controller?(controller:)
  end

  def active_journeys_tab?(tab: nil)
    return unless controller?(controller: 'journeys') || controller?(controller: 'journey_stops')
    return if active_controller_action?(controller: 'journeys', action: 'new')
    return my_journeys_tab?(tab:) if tab == 'mine'
    return bought_journeys_tab?(tab:) if tab == 'bought'

    all_journeys_tab?
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

  private

  def select_journeys_tab
    'btn-primary'
  end

  def not_selected_journeys_tab
    'btn-outline-primary'
  end

  def my_journeys_tab?(tab:)
    return unless tab == 'mine'
    return 'active' if params[:which_journeys] == tab || can_edit_current_journey?
  end

  def bought_journeys_tab?(tab:)
    return unless tab == 'bought'
    return 'active' if params[:which_journeys] == tab || bought_current_journey?
  end

  def all_journeys_tab?
    return if params[:which_journeys].present?
    return 'active' if !can_edit_current_journey? && !bought_current_journey?
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
