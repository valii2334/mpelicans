# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email    { FFaker::Internet.email }
    password { FFaker::Name.name }
    username { FFaker::Internet.user_name }

    # rubocop:disable Style/SymbolProc
    after(:create) do |user|
      user.confirm
    end
    # rubocop:enable Style/SymbolProc
  end
end
