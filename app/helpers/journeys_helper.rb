# frozen_string_literal: true

# Methods used by views in journeys
module JourneysHelper
  def journeys_page_title
    return 'Mine'   if params[:which_journeys] == 'mine'
    return 'Bought' if params[:which_journeys] == 'bought'

    'Latest'
  end

  def current_row_class(number_of_images:)
    return 'col-12' if number_of_images == 1

    'col-6'
  end
end
