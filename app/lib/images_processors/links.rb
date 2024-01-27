# frozen_string_literal: true

module ImagesProcessors
  class Links < ImagesProcessors::Base
    attr_accessor :imageable_id, :imageable_type

    # rubocop:disable Lint/MissingSuper
    def initialize(imageable_id:, imageable_type:)
      @imageable_id = imageable_id
      @imageable_type = imageable_type
    end
    # rubocop:enable Lint/MissingSuper

    def run_processor
      image_links = {}

      VARIANTS.each do |variant|
        image_links[variant] = imageable.images.map { |image| image.variant(variant).url }
      end

      imageable.update(image_links:)
    end

    private

    def enque_next_steps; end
  end
end
