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
      return latest_journeys       unless which_journeys

      return users_latest_journeys if users_journeys?
      return mine_journeys         if mine_journeys?
      return bought_journeys       if bought_journeys?

      []
    end

    private

    def latest_journeys
      ::Journey
        .includes(
          :user,
          uploaded_images: { imageable: :images }, journey_stops: { uploaded_images: { imageable: :images } }
        )
        .where(access_type: VIEWABLE_ACCESS_TYPES)
        .where(image_processing_status: :processed)
    end

    def users_latest_journeys
      user
        .journeys
        .includes(
          :user,
          uploaded_images: { imageable: :images }, journey_stops: { uploaded_images: { imageable: :images } }
        )
        .where(access_type: VIEWABLE_ACCESS_TYPES)
        .where(image_processing_status: :processed)
    end

    def bought_journeys
      user
        .bought_journeys
        .includes(
          :user,
          uploaded_images: { imageable: :images }, journey_stops: { uploaded_images: { imageable: :images } }
        )
        .where(access_type: VIEWABLE_ACCESS_TYPES)
    end

    def mine_journeys
      user
        .journeys
        .includes(
          :user,
          uploaded_images: { imageable: :images }, journey_stops: { uploaded_images: { imageable: :images } }
        )
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
