# frozen_string_literal: true

module Imageable
  extend ActiveSupport::Concern

  NUMBER_OF_DISPLAYED_IMAGES = 4
  NUMBER_OF_IMAGES_PER_ROW   = 2

  included do
    has_many_attached :images do |attachable|
      attachable.variant :thumbnail, resize_and_pad:  [1024, 1024]
      attachable.variant :max,       resize_to_limit: [2048, 2048]
    end

    enum image_processing_status: {
      waiting: 0,
      processing: 1,
      processed: 2
    }
  end

  def process_images
    images.each do |image|
      image.variant(:thumbnail).processed
      image.variant(:max).processed
    end
  end

  def images_thumbnail_urls
    image_urls(variant: :thumbnail)
  end

  def images_max_urls
    image_urls(variant: :max)
  end

  def thumbnails_grouped
    all_thumbnails
      .first(NUMBER_OF_DISPLAYED_IMAGES)
      .in_groups_of(NUMBER_OF_IMAGES_PER_ROW, false)
  end

  private

  def image_urls(variant:)
    return [] unless processed?

    images.map { |image| image.variant(variant).processed.url }
  end

  def images_are_present
    errors.add :images, :invalid, message: "can't be blank" if passed_images_count.zero?
  end
end
