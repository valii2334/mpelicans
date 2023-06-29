# frozen_string_literal: true

# Methods used by views in journeys
module JourneysHelper
  def journeys_page_title
    return 'My journeys'     if params[:which_journeys] == 'mine'
    return 'Bought journeys' if params[:which_journeys] == 'bought'

    'Latest journeys'
  end
end
