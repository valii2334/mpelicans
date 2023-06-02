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

    my_journeys_tab?(tab:) || bought_journeys_tab?(tab:) || all_journeys_tab?
  end

  private

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

  def journey_privacy_buttons(journey:)
    remaining_privacy_types(journey:).map do |remaining_privacy_type|
      journey_privacy_button(journey:, privacy_type: remaining_privacy_type)
    end
  end

  def journey_privacy_button(journey:, privacy_type:)
    link_to privacy_type.upcase_first,
            journey_path(
              journey,
              journey: {
                access_type: "#{privacy_type}_journey"
              }
            ),
            method: :put,
            confirm: 'Are you sure?',
            class: "btn btn-sm #{color_class(privacy_type:)}"
  end

  def color_class(privacy_type:)
    return 'btn-primary' if privacy_type == 'public'
    return 'btn-danger'  if privacy_type == 'private'
    return 'btn-warning' if privacy_type == 'protected'

    'btn-success'
  end

  def remaining_privacy_types(journey:)
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

  def content_style
    return 'padding-top: 10px;' if params[:controller].include?('devise')
  end
end
