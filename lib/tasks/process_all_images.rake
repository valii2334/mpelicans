# frozen_string_literal: true

desc 'Process all images'
task process_all_images: :environment do
  JourneyStop.all.each do |journey_stop|
    puts "Processing JourneyStop with id: #{journey_stop.id}"

    JourneyJobs::ProcessImages.perform_async(journey_stop.id, 'JourneyStop')

    sleep 10
  end

  Journey.all.each do |journey|
    puts "Processing Journey with id: #{journey.id}"

    JourneyJobs::ProcessImages.perform_async(journey.id, 'Journey')

    sleep 10
  end
end
