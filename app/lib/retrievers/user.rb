# frozen_string_literal: true

module Retrievers
  class User
    attr_accessor :query_string

    def initialize(query_string: nil)
      @query_string = query_string
    end

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
