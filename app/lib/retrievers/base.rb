# frozen_string_literal: true

module Retrievers
  class Base
    def fetch
      raise 'NotImplemented'
    end
  end
end
