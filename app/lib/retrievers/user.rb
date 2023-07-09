# frozen_string_literal: true

module Retrievers
  class User < Retrievers::Base
    attr_accessor :query_string

    # rubocop:disable Lint/MissingSuper
    def initialize(query_string: nil)
      @query_string = query_string
    end
    # rubocop:enable Lint/MissingSuper

    def fetch
      return ::User.all if query_string.blank?

      ::User.where('username ILIKE ?', sanitized_query_string)
    end

    private

    def sanitized_query_string
      "%#{ActiveRecord::Base.sanitize_sql_like(query_string)}%"
    end
  end
end
