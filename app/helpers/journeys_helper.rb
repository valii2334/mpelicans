# frozen_string_literal: true

# Methods used by views in journeys
module JourneysHelper
  def journeys_page_title
    return 'Mine'   if params[:which_journeys] == 'mine'
    return 'Bought' if params[:which_journeys] == 'bought'

    'Latest'
  end
end
