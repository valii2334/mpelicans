# frozen_string_literal: true

# Methods used by views in journeys
module JourneysHelper
  def journeys_page_title
    params[:which_journeys].camelize
  end
end
