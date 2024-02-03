# frozen_string_literal: true

# Methods used by views in journeys
module JourneysHelper
  # rubocop:disable Rails/HelperInstanceVariable
  def journeys_title
    return "MPelicans - #{@journey.title}"    if params[:action] == 'show'
    return 'MPelicans - Create a new journey' if params[:action] == 'new'

    'MPelicans - View Pictures From Amazing Places'
  end
  # rubocop:enable Rails/HelperInstanceVariable

  def journeys_page_title
    params[:which_journeys].camelize
  end
end
