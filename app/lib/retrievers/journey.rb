# frozen_string_literal: true

module Retrievers
  class Journey < Retrievers::Base
    VIEWABLE_ACCESS_TYPES = %i[public_journey monetized_journey].freeze

    attr_accessor :user, :which_journeys

    # rubocop:disable Lint/MissingSuper
    def initialize(user: nil, which_journeys: nil)
      @user = user
      @which_journeys = which_journeys
    end
    # rubocop:enable Lint/MissingSuper

    def fetch
      return users_latest_journeys if users_journeys?
      return mine_journeys         if mine_journeys?
      return bought_journeys       if bought_journeys?

      all_latest_journeys
    end

    private

    def all_latest_journeys
      ::Journey
        .includes(:user, :journey_stops)
        .where(access_type: VIEWABLE_ACCESS_TYPES)
        .where(image_processing_status: :processed)
    end

    def users_latest_journeys
      user
        .journeys
        .includes(:user, :journey_stops)
        .where(access_type: VIEWABLE_ACCESS_TYPES)
        .where(image_processing_status: :processed)
    end

    def bought_journeys
      user
        .bought_journeys
        .includes(:user, :journey_stops)
        .where(access_type: VIEWABLE_ACCESS_TYPES)
    end

    def mine_journeys
      user
        .journeys
        .includes(:user, :journey_stops)
    end

    def mine_journeys?
      which_journeys == 'mine'
    end

    def bought_journeys?
      which_journeys == 'bought'
    end

    def users_journeys?
      which_journeys == 'users'
    end
  end
end
