# frozen_string_literal: true

# Methods used by views in pelicans
module PelicansHelper
  # rubocop:disable Rails/HelperInstanceVariable
  def pelicans_title
    return "MPelicans - #{@user.username}" if @user

    'MPelicans - View Pictures From Amazing Places'
  end
  # rubocop:enable Rails/HelperInstanceVariable

  def journeys_page_title
    params[:which_journeys].camelize
  end
end
