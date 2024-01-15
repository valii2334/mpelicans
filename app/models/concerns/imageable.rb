# frozen_string_literal: true

require 'async'
require 'async/barrier'

module Imageable
  extend ActiveSupport::Concern

  included do
    has_many_attached :images do |attachable|
      attachable.variant :mini_thumbnail,
                         resize_to_fill: [400, 400],
                         format: :webp,
                         quality: 80

      attachable.variant :thumbnail,
                         resize_to_fill: [1024, 1024],
                         format: :webp,
                         quality: 80

      attachable.variant :mobile,
                         resize_to_limit: [1024, 1024],
                         format: :webp

      attachable.variant :max,
                         resize_to_limit: [2048, 2048],
                         format: :webp
    end

    enum image_processing_status: {
      waiting: 0,
      processing: 1,
      processed: 2
    }
  end

  def process_images
    barrier = Async::Barrier.new

    Async do
      images.each do |image|
        barrier.async do
          process_image(image:)
        end
      end
      barrier.wait
    end
  end

  def images_urls(variant:)
    image_urls(variant:)
  end

  private

  def process_image(image:)
    image.variant(:mini_thumbnail).processed
    image.variant(:thumbnail).processed
    image.variant(:mobile).processed
    image.variant(:max).processed
  end

  def image_urls(variant:)
    return [] unless processed?

    images.map { |image| image.variant(variant).processed.url }
  end

  def images_are_present
    errors.add :images, :invalid, message: "can't be blank" if passed_images_count.zero?
  end
end
