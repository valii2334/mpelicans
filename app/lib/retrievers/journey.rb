# frozen_string_literal: true

module Retrievers
  class Journey
    VIEWABLE_ACCESS_TYPES = %i[public_journey monetized_journey].freeze

    attr_accessor :user, :which_journeys

    def initialize(user: nil, which_journeys: nil)
      @user = user
      @which_journeys = which_journeys
    end

    def fetch
      return latest_journeys       unless which_journeys

      return users_latest_journeys if users_journeys?
      return mine_journeys         if mine_journeys?
      return bought_journeys       if bought_journeys?

      []
    end

    private

    def latest_journeys
      ::Journey
        .where(access_type: VIEWABLE_ACCESS_TYPES)
        .where(image_processing_status: :processed)
    end

    def users_latest_journeys
      user
        .journeys
        .where(access_type: VIEWABLE_ACCESS_TYPES)
        .where(image_processing_status: :processed)
    end

    def bought_journeys
      user
        .bought_journeys
        .where(access_type: VIEWABLE_ACCESS_TYPES)
    end

    def mine_journeys
      user.journeys
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
