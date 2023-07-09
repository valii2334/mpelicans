# frozen_string_literal: true

module ImagesProcessors
  class Base
    def run
      run_processor
      enque_next_steps
    end

    def run_processor
      raise 'NotImplemented'
    end

    private

    def enque_next_steps
      raise 'NotImplemented'
    end

    def imageable
      imageable_type.constantize.find(imageable_id)
    end
  end
end
