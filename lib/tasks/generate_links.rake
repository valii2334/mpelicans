# frozen_string_literal: true

desc 'Process all images'
task generate_links: :environment do
  JourneyStop.all.each do |journey_stop|
    puts "Processing JourneyStop with id: #{journey_stop.id}"

    ImagesProcessors::Links.new(imageable_id: journey_stop.id, imageable_type: 'JourneyStop').run
  end

  Journey.all.each do |journey|
    puts "Processing Journey with id: #{journey.id}"

    ImagesProcessors::Links.new(imageable_id: journey.id, imageable_type: 'Journey').run
  end
end
