# frozen_string_literal: true

desc 'Process all images'
task process_all_images: :environment do
  JourneyStop.find_each do |journey_stop|
    puts "Processing JourneyStop with id: #{journey_stop.id}"

    JourneyJobs::ProcessImages.perform_async(journey_stop.id, 'JourneyStop')

    sleep 60
  end

  Journey.find_each do |journey|
    puts "Processing Journey with id: #{journey.id}"

    JourneyJobs::ProcessImages.perform_async(journey.id, 'Journey')

    sleep 60
  end
end
