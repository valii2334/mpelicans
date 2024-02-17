# frozen_string_literal: true

module JourneyImagesConcern
  def journey_mini_thumbnails
    images_urls(variant: :mini_thumbnail)
  end

  def journey_thumbnails
    images_urls(variant: :thumbnail)
  end

  def journey_mobiles
    images_urls(variant: :mobile)
  end

  def journey_maxs
    images_urls(variant: :max)
  end

  def all_mini_thumbnails
    [
      journey_stops.map(&:all_mini_thumbnails),
      journey_mini_thumbnails
    ].flatten
  end

  def all_thumbnails
    [
      journey_stops.map(&:all_thumbnails),
      journey_thumbnails
    ].flatten
  end

  def all_mobiles
    [
      journey_stops.map(&:all_mobiles),
      journey_mobiles
    ].flatten
  end

  def all_maxs
    [
      journey_stops.map(&:all_maxs),
      journey_maxs
    ].flatten
  end
end
