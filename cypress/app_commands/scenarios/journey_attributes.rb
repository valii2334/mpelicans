# frozen_string_literal: true

journey            = Journey.find_by(title: command_options['journey_title'])
journey_attributes = journey.attributes
journey_attributes['description'] = journey.description.body
journey_attributes
