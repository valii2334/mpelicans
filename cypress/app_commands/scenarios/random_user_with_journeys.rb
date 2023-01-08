# frozen_string_literal: true

user = FactoryBot.create(:user, username: command_options['username'])

command_options['journeys'].each do |journey|
  FactoryBot.create(:journey, { user: }.merge(journey))
end
