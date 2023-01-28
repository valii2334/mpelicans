# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email    { FFaker::Internet.email }
    password { FFaker::Name.name }
    username { FFaker::Internet.user_name }

    after(:create) do |user|
      user.confirm
    end
  end
end
