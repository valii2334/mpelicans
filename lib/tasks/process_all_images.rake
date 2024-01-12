desc 'Process all images'
task :process_all_images => :environment do
  JourneyStop.all.in_groups_of(10, false) do |journey_stop_group|
    puts "Processing a group of #{journey_stop_group.count} JourneyStops"

    journey_stop_group.each do |journey_stop|
      JourneyJobs::ProcessImages.perform_async(journey_stop.id, 'JourneyStop')
    end

    sleep 60
  end

  Journey.all.in_groups_of(10, false) do |journeys_group|
    puts "Processing a group of #{journeys_group.count} Journeys"

    journeys_group.each do |journey|
      JourneyJobs::ProcessImages.perform_async(journey.id, 'Journey')
    end

    sleep 60
  end
end