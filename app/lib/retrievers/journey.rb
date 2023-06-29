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
      return latest_journeys       unless user
      return users_latest_journeys if which_journeys.blank?
      return mine_journeys         if mine_journeys?
      return bought_journeys       if bought_journeys?

      return []
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

    def mine_journeys?
      which_journeys == 'mine'
    end

    def mine_journeys
      user.journeys
    end

    def bought_journeys?
      which_journeys == 'bought'
    end

    def bought_journeys
      user
        .bought_journeys
        .where(access_type: VIEWABLE_ACCESS_TYPES)
    end
  end
end
