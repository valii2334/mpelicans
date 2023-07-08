# frozen_string_literal: true

# Methods used by views in journeys
module JourneysHelper
  def journeys_page_title
    return 'Mine'   if params[:which_journeys] == 'mine'
    return 'Bought' if params[:which_journeys] == 'bought'

    'Latest'
  end

  def current_row_glass(number_of_groups:, current_group_count:)
    return 'col-4'  if number_of_groups > 1
    return 'col-12' if current_group_count == 1

    'col-6'
  end
end
