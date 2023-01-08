# frozen_string_literal: true

FactoryBot.create(:journey, { user: User.last }.merge(command_options))
